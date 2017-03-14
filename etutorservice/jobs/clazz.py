# -*- coding: utf-8 -*-

import arrow
import logging

from etutorservice.utils.config_helper import config
from etutorservice.utils.datetime_helper import get_now, format_date
from etutorservice.common.db import db_session_manager
from etutorservice.logic.class_manage import ClassSuperviseManager
from etutorservice.logic.class_template_place import ClassTemplatePlaceManager
from etutorservice.logic.temporary_substitute_coach_task import \
    TemporarySubstituteCoachTaskManager
from etutorservice.logic.correct_coach_status import \
    CorrectCoachStatusTaskManager
from etutorservice.logic.class_template import ClassTemplateManager

logger = logging.getLogger(__name__)


def run(parameter):
    if len(parameter) < 1:
        print('parameter not valid')
        return

    action = parameter[0]
    testing = config.data['testing']

    if testing and len(parameter) >= 2:
        time_text = parameter[1]
    else:
        time_text = None

    if action == 'check_on_time':
        _check_not_on_time_coaches(time_text)
    elif action == 'morning_notify':
        _next_day_notify()
    elif action == 'not_morning_notify':
        _not_morning_notify(time_text)
    elif action == 'init_place':
        _init_place(time_text)
    elif action == 'remove_expired_students':
        _remove_expired_students(time_text)
    elif action == 'free_available_time':
        _free_available_time(time_text)
    elif action == 'correct_coach_status':
        _correct_coach_status()
    elif action == 'calculate_enrollment_schedule':
        _calculate_enrollment_schedule()
    elif action == 'close_none_student_continue_class':
        _close_none_student_continue_class(time_text)
    else:
        print('action not valid %s' % parameter)


# 教师没有提前10分钟登录教练端的通知。
def _check_not_on_time_coaches(now_time):
    logger.info('start check not on time coaches. now time: %s' % now_time)

    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        manager.check_not_on_time_coaches(now_time)

    logger.info('create tasks end.')


# 每天晚上8点运行一次（一天一次）
def _next_day_notify():
    logger.info('start next day class notify')

    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        manager.notify_next_day_class()

    logger.info('next day class notify end.')


# 每分钟运行一次，从上午8点开始，到晚上8点结束。
def _not_morning_notify(time_text):
    return


# 每天运行一次。
def _init_place(time_text):
    logger.info('start init place')

    with db_session_manager.with_session() as db_session:
        manager = ClassTemplatePlaceManager(db_session)
        manager.init_all_place_data(time_text)

    logger.info('init place end.')


def _remove_expired_students(time_text):
    logger.info('remove expired students')

    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        manager.process_expired_student(time_text)

    logger.info('remove expired students end.')


def _free_available_time(time_text):
    logger.info('free available time')

    with db_session_manager.with_session() as db_session:
        manager = TemporarySubstituteCoachTaskManager(db_session)
        manager.process_need_free_available_time_task(time_text)

    logger.info('free available time end.')


def _correct_coach_status():
    logger.info('correct coach status')
    with db_session_manager.with_session() as db_session:
        manager = CorrectCoachStatusTaskManager(db_session)
        manager.process_correct_coach_status()

    logger.info('correct coach status end.')


def _calculate_enrollment_schedule():
    logger.info('correct coach status')
    with db_session_manager.with_session() as db_session:
        manager = ClassTemplateManager(db_session)
        today = format_date(get_now())
        manager.calculate_enrollment_schedule(today)

    logger.info('correct coach status end.')

def _close_none_student_continue_class(time_text):
    logger.info('close none student continue class')
    with db_session_manager.with_session() as db_session:
        manager = ClassSuperviseManager(db_session)
        manager.close_none_student_continue_class(time_text)
    logger.info('close none student continue class end')
