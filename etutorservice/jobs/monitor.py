# -*- coding: utf-8 -*-
import logging
from etutorservice.utils.config_helper import config
from etutorservice.common.db import db_session_manager
from etutorservice.logic.monitor import MonitorManager
logger = logging.getLogger(__name__)


def run(parameter):
    if len(parameter) < 1:
        logger.debug('parameter not valid')
        return

    action = parameter[0]
    testing = config.data['testing']

    if action == "monitor":
        _monitor_disconnect()
        _monitor_none()
    else:
        logger.debug('action not valid %s' % parameter)


def _monitor_disconnect():
    logger.info('start monitor teacher disconnect.')
    with db_session_manager.with_session() as db_session:
        manager = MonitorManager(db_session)
        manager.notify_disconnect()

    logger.info('monitor teacher disconnect end.')


def _monitor_none():
    logger.info('start monitor none student. day')
    with db_session_manager.with_session() as db_session:
        manager = MonitorManager(db_session)
        manager.notify_none()
    logger.info('monitor none student end.')
