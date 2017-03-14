# -*- coding: utf-8 -*-

import arrow
import logging

from etutorservice.utils.config_helper import config
from etutorservice.common.db import db_session_manager
from etutorservice.logic.class_allocation import ClassAllocationManager
from etutorservice.logic.class_create_task import ClassCreateTaskManager
from etutorservice.logic.coach_invite import CoachInviteManager

logger = logging.getLogger(__name__)


def run(parameter):
    if len(parameter) < 1:
        print('parameter not valid')
        return

    action = parameter[0]
    testing = config.data['testing']

    if testing and len(parameter) >= 2:
        day_text = parameter[1]
    else:
        day_text = _get_day_text()

    day = arrow.get(day_text).datetime.date()

    if action == 'exec':
        _exec_invite(day)
    elif action == 'check':
        _check_invite()
        _check_tasks(day)
    elif action == 'create':        # 每天凌晨执行一次即可
        _create_task(day)
    elif action == 'notify_test':   # 每天的17点和22点运行
        _notify_need_test_coaches()
    elif action == 'notify_class':  # 每分钟或者从整点开始每30分钟（匹配上开班时间）执行一次
        _task_manager_notify()
    else:
        print('action not valid %s' % parameter)


def _get_day_text():
    return arrow.now('+08:00').replace(days=+3).format('YYYY-MM-DD')


# 创建组班任务。每天凌晨执行一次即可
def _create_task(day):
    logger.info('start create tasks. day: %s' % day)

    with db_session_manager.with_session() as db_session:
        manager = ClassAllocationManager(db_session)
        manager.create_tasks(day)

    logger.info('create tasks end.')


# 老师邀请
def _exec_invite(day):
    logger.info('start exec invite. day: %s' % day)

    with db_session_manager.with_session() as db_session:
        manager = ClassAllocationManager(db_session)
        task_manager = ClassCreateTaskManager(db_session)
        tasks = task_manager.get_need_invite_coach_tasks(day)
        for task in tasks:
            coaches = manager.search_coach(task)
            print(task.id, coaches)

    logger.info('exec invite end.')


# 检查老师邀请是否过期
def _check_invite():
    logger.info('start check invite.')

    with db_session_manager.with_session() as db_session:
        manager = CoachInviteManager(db_session)
        num = manager.process_expired_invite()
        print('process %d invites' % num)

    logger.info('check invite end.')


# 检查组班任务教练是否找齐
def _check_tasks(day):
    logger.info('start check tasks.')

    with db_session_manager.with_session() as db_session:
        task_manager = ClassCreateTaskManager(db_session)
        invite_manager = CoachInviteManager(db_session)
        tasks = task_manager.get_inviting_tasks(day)
        for task in tasks:
            invites = invite_manager.get_task_success_invite(task.id)
            if len(invites) >= task.new_class_num:
                task_manager.set_task_to_invite_complete(task.id)
                logger.info('task: %d invite complete.' % task.id)

    logger.info('check tasks end.')


# 开班前26小时教练还没有找齐的通知。每分钟或者从整点开始每30分钟（匹配上开班时间）执行一次
def _task_manager_notify():
    logger.info('start task manager notify')

    with db_session_manager.with_session() as db_session:
        manager = ClassCreateTaskManager(db_session)
        manager.task_manager_notify()

    logger.info('task manager notify end.')


# 教练还未进行软件测试，最后2小时通知。每天的17点和22点运行
def _notify_need_test_coaches():
    logger.info('start notify need test coaches.')

    with db_session_manager.with_session() as db_session:
        manager = CoachInviteManager(db_session)
        manager.notify_need_test_coaches()

    logger.info('notify need test coaches end.')
