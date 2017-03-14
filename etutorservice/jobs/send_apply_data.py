# -*- coding: utf-8 -*-

import logging

from etutorservice.utils.datetime_helper import combine, to_date, to_datetime
from etutorservice.common.db import db_session_manager
from etutorservice.logic.etutor_web import WebInterface
from etutorservice.logic.class_template import ClassTemplateManager
from etutorservice.logic.clazz import ClassInfoManager

logger = logging.getLogger(__name__)


def _send_apply_data(student, class_id, edition, start_time_text, end_time_text):
    with db_session_manager.with_session() as db_session:
        class_info_manager = ClassInfoManager(db_session)
        class_info = class_info_manager.get_class_by_id(class_id)
        if not class_info:
            return False
        start_time = to_datetime(start_time_text)
        end_time = to_datetime(end_time_text)
        class_template = class_info['class_template']
        class_template_manager = ClassTemplateManager(db_session)
        plan = class_template_manager.generate_lesson_plan(
            class_template, start_time.date(), end_time.date())
        date_list = [item['day'] for item in plan]
        api = WebInterface()
        # 向客户端发送报名信息
        api.insert_apply_info(start_time_text, end_time_text, student,
                              edition, date_list, class_template.subject_id,
                              class_template.grade)
        for item in plan:
            api.update_apply_status(
                '%s %s' % (item['day'], item['start_time']),
                '%s %s' % (item['day'], item['end_time']),
                'success', [student])
        return True


def run(parameter):
    logger.info('start')
    # _send_apply_data('marstest', 100, 8, '2016-04-01 20:00:00',
    #                  '2016-07-08 21:30:00')
    logger.info('end')
