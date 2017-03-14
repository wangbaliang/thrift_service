# -*- coding: utf-8 -*-

import logging

from etutorservice.common.db import db_session_manager
from etutorservice.logic.class_manage import (
    ClassSuperviseManager, ClassManger,
)

logger = logging.getLogger(__name__)


def _sync_class_info(manager, class_info):
    reservations = manager.get_class_reservation_students(class_info.id)
    students = set([reservation.student for reservation in reservations])
    class_students = set(class_info.get_student_info())
    if students == class_students:
        return True
    logger.info('class: %s, student not same， old: %s, new: %s'
                % (class_info.id, class_students, students))
    class_info.set_student_info(list(students))
    return True


def _sync_all_class():
    with db_session_manager.with_session() as db_session:
        class_supervise_manager = ClassSuperviseManager(db_session)
        class_manager = ClassManger(db_session)
        all_classes = class_manager.get_all(10000, need_extend=False)
        for class_info, class_template, season in all_classes:
            _sync_class_info(class_supervise_manager, class_info)
        db_session.commit()


def run(parameter):
    logger.info('start')
    _sync_all_class()
    logger.info('end')
