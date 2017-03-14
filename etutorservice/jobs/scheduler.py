# -*- coding: utf-8 -*-

import logging

from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.events import (
    EVENT_JOB_ERROR,
    EVENT_JOB_MISSED,
    EVENT_SCHEDULER_START,
    EVENT_SCHEDULER_SHUTDOWN
)

from etutorservice.utils.config_helper import config
from etutorservice.utils.datetime_helper import get_now, format_date
from etutorservice.utils.sms_helper import MessageSender
from etutorservice.utils.mail_helper import MailSender
from etutorservice.common.db import db_session_manager
from etutorservice.logic.sms import SmsMessageManager
from etutorservice.logic.mail import MailMessageManager
from etutorservice.logic.class_manage import ClassSuperviseManager
from etutorservice.logic.class_template import ClassTemplateManager
from etutorservice.logic.class_template_place import ClassTemplatePlaceManager
from etutorservice.logic.class_allocation import ClassAllocationManager
from etutorservice.logic.class_create_task import ClassCreateTaskManager
from etutorservice.logic.coach_invite import CoachInviteManager
from etutorservice.logic.temporary_substitute_coach_task import TemporarySubstituteCoachTaskManager
from etutorservice.logic.correct_coach_status import CorrectCoachStatusTaskManager
from etutorservice.logic.class_coach import ClassCoachManager
from etutorservice.logic.monitor import MonitorManager
from etutorservice.logic.continue_class import ContinueClassManager
from etutorservice.logic.service_reservation import ServiceReservationManager
from etutorservice.logic.business import SaleCardManager

logger = logging.getLogger(__name__)

scheduler = BlockingScheduler({
    'apscheduler.executors.default': {
        'class': 'apscheduler.executors.pool:ThreadPoolExecutor',
        'max_workers': '20'
    },
    'apscheduler.timezone': 'Asia/Shanghai'
})

mail_sender = MailSender()


def _notify_scheduler(event):
    if event.code == EVENT_SCHEDULER_START:
        content = 'scheduler start now %s' % get_now()
    elif event.code == EVENT_SCHEDULER_SHUTDOWN:
        content = 'scheduler shutdown now %s' % get_now()
    else:
        content = 'unknown'
    mail_sender.send_email(config.data['system_admin_email_list'],
                           'scheduler notify', content)

scheduler.add_listener(_notify_scheduler,
                       EVENT_SCHEDULER_START | EVENT_SCHEDULER_SHUTDOWN)


def notify_error(event):
    if event.code == EVENT_JOB_ERROR:
        content = 'job: %s failed - %s - exception: %s - traceback: %s' \
                  % (event.job_id, event.scheduled_run_time,
                     event.exception, event.traceback)
    elif event.code == EVENT_JOB_MISSED:
        content = 'job: %s missed - %s ' % (event.job_id,
                                            event.scheduled_run_time)
    else:
        content = 'unknown'
    mail_sender.send_email(config.data['system_admin_email_list'],
                           'job error notify', content)

scheduler.add_listener(notify_error, EVENT_JOB_ERROR | EVENT_JOB_MISSED)


@scheduler.scheduled_job('cron', id='calculate_enrollment_schedule', hour=2)
def _class_enrollment_schedule_calculate():
    """
    计算学生报名情况，每天凌晨2点执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        today_date = get_now().strftime('%Y-%m-%d')
        manager = ClassTemplateManager(db_session)
        manager.calculate_enrollment_schedule(today_date)


@scheduler.scheduled_job('interval', id='send_sms', minutes=1)
def _send_sms():
    """
    发送短信定时任务，每分钟运行一次。
    :return:
    """
    if config.data.get('testing'):
        # 测试中，不发短信
        return
    with db_session_manager.with_session() as db_session:
        sender = MessageSender()
        manager = SmsMessageManager(db_session)
        sms_list = manager.get_need_send_sms()
        for sms in sms_list:
            try:
                sender.send_same_message_bulk(sms.get_phone_numbers(), sms.content)
                manager.set_sms_is_send([sms.id])
            except Exception as error:
                logger.exception(error.message)


@scheduler.scheduled_job('interval', id='send_mail', minutes=1)
def _send_mail():
    """
    发送邮件定时任务，每分钟运行一次。
    :return:
    """
    if config.data.get('testing'):
        # 测试中，不发邮件
        return
    from_address = config.data['smtp']['user_name']

    has_sent_mail_ids = []
    with db_session_manager.with_session() as db_session:
        manager = MailMessageManager(db_session)
        mail_list = manager.get_need_send_mail()
        for mail in mail_list:
            try:
                mail_sender.send_email(mail.get_mail_addresses(),
                                       mail.title,
                                       mail.content,
                                       from_address)
                has_sent_mail_ids.append(mail.id)
            except Exception as error:
                logger.exception(error.message)
    if has_sent_mail_ids:
        manager.set_mail_is_send(has_sent_mail_ids)


@scheduler.scheduled_job('cron', id='init_class_template_place', hour=2)
def _init_class_template_place():
    """
    初始化班型剩余名额占用缓存数据，每天凌晨2点执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassTemplatePlaceManager(db_session)
        manager.init_all_place_data()


@scheduler.scheduled_job('cron', id='class_create', hour=2)
def _class_create():
    """
    清除班级过期学员、释放教师可用时段、创建组班任务，每日凌晨2点执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        manager.process_expired_student()

    with db_session_manager.with_session() as db_session:
        manager = TemporarySubstituteCoachTaskManager(db_session)
        manager.process_need_free_available_time_task()

    with db_session_manager.with_session() as db_session:
        manager = ClassAllocationManager(db_session)
        manager.create_tasks(get_now().replace(days=+3).date())


@scheduler.scheduled_job('cron', id='next_day_class_notify', hour=20)
def _next_day_class_notify():
    """
    第二天课通知任务（第二天上的课，前一天晚上8点进行通知），每日晚上8点执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        manager.notify_next_day_class()


@scheduler.scheduled_job('cron', id='notify_need_test_coaches', hour='18,22')
def _notify_need_test_coaches():
    """
    已接受邀请但在软件测试截止时间前还没通过测试的教练，在测试截止时间前2小时提醒教练去测试
    （上午接受邀请的教练软件测试截止晚上8点，非上午接受的截止晚上12点），每日下午5点和晚上10点执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = CoachInviteManager(db_session)
        manager.notify_need_test_coaches()


@scheduler.scheduled_job('cron', id='check_not_on_time_coaches', hour='6-23', minute='5-59/15')
def _check_not_on_time_coaches():
    """
    检查没有准时上课的教练（教练必须上课前10分钟登录系统），每日早上6点至晚上11点的1至59分每15分钟执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        manager.check_not_on_time_coaches()


@scheduler.scheduled_job('cron', id='assign_students', minute='0-59/15')
def _assign_students():
    """
    在上课前3小时为新开班分配教练和学员，每日的早上4点至晚上8点，每15分钟执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassAllocationManager(db_session)
        task_manager = ClassCreateTaskManager(db_session)
        tasks = task_manager.get_need_assign_student_tasks()
        for task in tasks:
            try:
                result = manager.assign_students(task)
                logger.info('task(%s): %s' % (task.id, result))
            except Exception as error:
                logger.exception(error.message)


@scheduler.scheduled_job('cron', id='task_coach_not_ready_notify', hour='2-18', minute='0-59/15')
def _task_coach_not_ready_notify():
    """
    开班预警通知，新开班如果在开班前26小时还没有找齐教练，通知教务，每日的早上2点至下午6点，每15分钟执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassCreateTaskManager(db_session)
        manager.task_manager_notify()


@scheduler.scheduled_job('cron', id='check_and_invite_coach', hour='6-24', minute='*')
def _check_and_invite_coach():
    """
    教练开班邀请定时任务，主要处理：
    1. 教练邀请过期检查及处理；
    2. 教练自动邀请；
    3. 如果教练已找齐，设置邀请完成
    每日早上6点到晚上12点，每分钟运行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = CoachInviteManager(db_session)
        num = manager.process_expired_invite()
        logger.info('process %d invites' % num)

    day = get_now().replace(days=+3).date()

    with db_session_manager.with_session() as db_session:
        manager = ClassAllocationManager(db_session)
        task_manager = ClassCreateTaskManager(db_session)
        tasks = task_manager.get_need_invite_coach_tasks(day)
        for task in tasks:
            coaches = manager.search_coach(task)
            logger.info('task(%s): %s' % (task.id, coaches))

    with db_session_manager.with_session() as db_session:
        task_manager = ClassCreateTaskManager(db_session)
        invite_manager = CoachInviteManager(db_session)
        tasks = task_manager.get_inviting_tasks(day)
        for task in tasks:
            invites = invite_manager.get_task_success_invite(task.id)
            if len(invites) >= task.new_class_num:
                task_manager.set_task_to_invite_complete(task.id)
                logger.info('task: %d invite complete.' % task.id)


@scheduler.scheduled_job('cron', id='correct_coach_status', hour=2)
def _correct_coach_status():
    """
    矫正储备、待岗、在岗老师的状态，每天凌晨2点执行一次
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = CorrectCoachStatusTaskManager(db_session)
        manager.process_correct_coach_status()


@scheduler.scheduled_job('interval', id='notify_disconnect', minutes=1)
def _notify_disconnect():
    """
    通知教务处理掉线的班级，每分钟运行一次
    """
    with db_session_manager.with_session() as db_session:
        manager = MonitorManager(db_session)
        manager.notify_disconnect()


@scheduler.scheduled_job('interval', id='notify_none', minutes=10)
def _notify_none():
    """
    通知教务处理没有学生的班级，每十分钟运行一次
    """
    with db_session_manager.with_session() as db_session:
        manager = MonitorManager(db_session)
        manager.notify_none()


@scheduler.scheduled_job('cron', id='auto_change_coach', hour='6-24',
                         minute='*')
def _auto_change_coach():
    """
    自动更换可用时段结束的班级教练，自动找教练添加更换教练任务、发邀请。
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassCoachManager(db_session)
        days = [
            get_now().replace(days=+7).date(),
            get_now().replace(days=+8).date(),
        ]
        for class_day in days:
            class_list = manager.get_need_change_coach_class_list(class_day)
            for class_info in class_list:
                result = manager.start_change_coach(class_info, class_day)
                logger.info('change class (%s): %s' % (class_info.id, result))
            if not class_list:
                logger.info('day (%s) no class need change coach'
                            % format_date(class_day))


@scheduler.scheduled_job('cron', id='daily_complete_change_coach', hour=3)
def _daily_complete_change_coach():
    """
    自动完成教练更换，将当天需要替换的教练完成替换。
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassCoachManager(db_session)
        day = get_now().date()
        process_count = manager.daily_complete_change_task(day)
        logger.info('daily complete change coach process count: %s'
                    % process_count)


@scheduler.scheduled_job('cron', id='daily_check_fail_change_coach_task', hour=3)
def _daily_check_fail_change_coach_task():
    """
    检查自动换老师失败任务
    :return:
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassCoachManager(db_session)
        day = get_now().replace(days=+6).date()
        manager.notify_fail_change_class(day)
        logger.info('daily check fail change coach task')


@scheduler.scheduled_job('cron', id='daily_check_coach_continue_class', hour=20)
def _daily_check_coach_continue_class():
    """
    提醒教练设置续接班
    """
    with db_session_manager.with_session() as db_session:
        manager = ContinueClassManager(db_session)
        day = get_now().date()
        manager.auto_check(day)
        logger.info('daily check coach continue class')


@scheduler.scheduled_job('cron', id='daily_notify_no_continue_class_coaches', hour=10)
def _daily_notify_no_continue_class_coaches():
    """
    提醒教务：已短信提醒教练设置续接班3次 当前续接班仍为0的教练
    """
    with db_session_manager.with_session() as db_session:
        manager = ContinueClassManager(db_session)
        day = get_now().date()
        manager.notify_admin_no_set_continue_class_coaches(day)
        logger.info('daily check coach continue class')


@scheduler.scheduled_job('cron', id='daily_notify_coach_continue_class_start', hour=20)
def _daily_notify_coach_continue_class_start():
    """
    提前7天、3天提醒教练续接班即将开课
    """
    with db_session_manager.with_session() as db_session:
        manager = ContinueClassManager(db_session)
        day = get_now().date()
        manager.notify_coach_continue_class_start(day)
        logger.info('daily check coach continue class')


@scheduler.scheduled_job('cron', id='daily_check_expired_class', hour=2)
def _daily_check_expired_class():
    """
    关闭过期班级
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        day = get_now().date()
        manager.auto_close_expired_classes(day)
        logger.info('daily check expired class')


@scheduler.scheduled_job('cron', id='close_none_student_continue_class', hour=0)
def _close_none_student_continue_class():
    """
    学季开始前第4天, 关闭没有学生的续接班
    """
    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        result = manager.close_none_student_continue_class()
        if result:
            logger.info('has closed none student continue class')
        else:
            logger.info('not close none student continue class')


@scheduler.scheduled_job('cron', id='send_everyday_reservation', hour=9)
def _send_everyday_reservation():
    """
    获取前一天报名学员的信息
    （约课日期、学员账号、姓名、手机、时段、课程开始日期、课程结束日期）
    """
    with db_session_manager.with_session() as db_session:
        today = get_now()
        start_time = format_date(today.replace(days=-1))
        end_time = format_date(today)
        manager = ServiceReservationManager(db_session)
        manager.send_reservation_by_time(start_time, end_time)
        logger.info('daily_send_everyday_reservation')


@scheduler.scheduled_job('cron', id='everyday_add_sale_cards', hour=0)
def _everyday_add_sale_cards():
    """
     每天矫正销售卡信息
    """
    with db_session_manager.with_session() as db_session:
        manager = SaleCardManager(db_session)
        manager.everyday_add_sale_cards()
        logger.info('daily_everyday_add_sale_cards')


def _main():
    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()


def run(parameter):
    _main()
