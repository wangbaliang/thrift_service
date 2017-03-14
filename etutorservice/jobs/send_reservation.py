# -*- coding: utf-8 -*-

import logging
import arrow

from etutorservice.common.db import db_session_manager
from etutorservice.logic.service_reservation import ServiceReservationManager
from etutorservice.utils.datetime_helper import format_date, get_now

logger = logging.getLogger(__name__)


def run(parameter):
    today = get_now()
    if len(parameter) == 1:
        start_time = format_date(parameter[0])
        end_time = format_date(today, 'YYYY-MM-DD HH:mm:ss')
    else:
        start_time = format_date(today.replace(days=-1))
        end_time = format_date(today)

    with db_session_manager.with_session() as db_session:
        manager = ServiceReservationManager(db_session)
        logger.info('start send reservation from {} to {}.'.format(start_time, end_time))
        manager.send_reservation_by_time(start_time, end_time)
        logger.info('end send reservation.')
