# -*- coding: utf-8 -*-

import arrow
import logging

from etutorservice.utils.config_helper import config
from etutorservice.common.db import db_session_manager
from etutorservice.logic.student import StudentManager


def run(parameter):
    with db_session_manager.with_session() as db_session:
        manager = StudentManager(db_session)
        manager.import_student([
            'marstest',])
