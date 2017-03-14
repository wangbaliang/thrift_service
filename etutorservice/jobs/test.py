# -*- coding: utf-8 -*-
import arrow
import logging

from etutorservice.utils import sms_helper
from etutorservice.utils.mail_helper import MailSender
from etutorservice.utils.config_helper import config
from etutorservice.jobs.scheduler import (
    _class_enrollment_schedule_calculate,   # 2
    _init_class_template_place,             # 2
    _class_create,                          # 2
    _correct_coach_status,                  # 2
    _daily_complete_change_coach,           # 3
    _daily_check_fail_change_coach_task,    # 3
    _daily_check_expired_class,             # 2
    _close_none_student_continue_class,     # 0
    _send_mail
)

logger = logging.getLogger(__name__)


def _test_sms():
    sender = sms_helper.MessageSender()
    result = sender.send_same_message_bulk(['15601127618'], u'just test. 测试OK。')
    logger.info(result)


def _test_email():
    sender = MailSender()
    sender.send_email(['wuruimiao@jiandan100.cn'], u'测试', u'测试邮件')


def _test_config_settings():
    logger.info(config.data['settings'])
    logger.info(arrow.now('+08:00').replace(hours=26).format('YYYY-MM-DD HH:mm:ss'))


def main():
    # _test_sms()
    _test_email()
    _test_config_settings()


def __safe_call(method):
    logger.info('start %s' % method.__name__)
    try:
        method()
    except Exception as error:
        logger.error(error)
    logger.info('%s end' % method.__name__)


def _exec_jobs():
    __safe_call(_close_none_student_continue_class)
    __safe_call(_daily_check_expired_class)
    __safe_call(_class_create)
    __safe_call(_init_class_template_place)
    __safe_call(_correct_coach_status)
    __safe_call(_daily_complete_change_coach)
    __safe_call(_daily_check_fail_change_coach_task)
    __safe_call(_class_enrollment_schedule_calculate)
    __safe_call(_send_mail)


def run(parameter):
    if len(parameter) < 1:
        main()
    else:
        action = parameter[0]
        if action == 'exec_jobs':
            logger.info('start jobs')
            _exec_jobs()
            logger.info('jobs exec end')

if __name__ == '__main__':
    main()
