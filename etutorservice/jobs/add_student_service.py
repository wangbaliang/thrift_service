# -*- coding: utf-8 -*-

import json
import logging

from etutorservice.utils.datetime_helper import combine, to_date
from etutorservice.common.db import db_session_manager
from etutorservice.logic.etutor_web import WebInterface
from etutorservice.logic.class_template import ClassTemplateManager
from etutorservice.logic.clazz import ClassInfoManager
from etutorservice.models import K12Grade

logger = logging.getLogger(__name__)


def _add_student_service(student, class_id, start_day, end_day):
    start_day = to_date(start_day)
    end_day = to_date(end_day)
    with db_session_manager.with_session() as db_session:
        class_manager = ClassInfoManager(db_session)
        class_list = class_manager.get_by_id_list([class_id])
        if not class_list:
            return False
        class_info = class_list[0]
        class_template_manager = ClassTemplateManager(db_session)
        class_template = class_template_manager.get_by_id(class_info.class_template_id)
        if not class_template:
            return False
        api = WebInterface()
        grade = K12Grade.to_ch_str(class_template.grade)
        subject = class_template.subject_id
        service_info = []
        plan = class_template_manager.generate_lesson_plan(class_template, start_day, end_day, need_string=False)
        for item in plan:
            day_info = item['day']
            start_time = combine(day_info, item['start_time'])
            start_timestamp = api.to_timestamp(start_time)
            end_time = combine(day_info, item['end_time'])
            end_timestamp = api.to_timestamp(end_time)
            service_info.append({
                'classroomId': class_id,
                'teacherName': class_info.coach,
                'startTime': start_timestamp,
                'endTime': end_timestamp,
                'grade': grade,
                'subject': subject,
                'students': [student]
            })
        return api.add_students_services(service_info)


def run(parameter):
    logger.info('start')
    _add_student_service('Helenwanghongli', 437, '2017-01-23 08:00:00', '2017-01-24 10:00:00')
    _add_student_service('qj692040',        548, '2017-01-23 08:00:00', '2017-01-23 10:00:00')
    _add_student_service('a18958557123',    565, '2017-01-23 13:30:00', '2017-02-09 15:30:00')
    _add_student_service('wanghuiabc123456',395, '2017-01-23 16:00:00', '2017-01-25 18:00:00')
    _add_student_service('yanlina1974518',  567, '2017-01-23 16:00:00', '2017-02-09 18:00:00')
    _add_student_service('Angelscomeon',    560, '2017-01-23 19:00:00', '2017-02-09 21:00:00')

    _add_student_service('hjz2002',            395, '2017-02-10 16:00:00', '2017-02-10 18:00:00')
    _add_student_service('LIUXING18291809910', 503, '2017-02-06 19:00:00', '2017-02-09 21:00:00')

    logger.info('end')
