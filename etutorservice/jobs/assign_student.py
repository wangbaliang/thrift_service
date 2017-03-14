# -*- coding: utf-8 -*-

import arrow
import logging

from etutorservice.common.db import db_session_manager
from etutorservice.logic.class_allocation import ClassAllocationManager
from etutorservice.logic.class_create_task import ClassCreateTaskManager


logger = logging.getLogger(__name__)


def run(parameter):
    if len(parameter) >= 1:
        day_text = parameter[0]
        start_time = arrow.get(day_text).format('YYYY-MM-DD HH:mm')
        logger.info('start assign students. start time: %s' % start_time)
    else:
        start_time = None
        logger.info('start assign students.')

    with db_session_manager.with_session() as db_session:
        manager = ClassAllocationManager(db_session)
        task_manager = ClassCreateTaskManager(db_session)
        tasks = task_manager.get_need_assign_student_tasks(start_time)
        for task in tasks:
            result = manager.assign_students(task)
            print(task.id, result)

    logger.info('assign students end.')
