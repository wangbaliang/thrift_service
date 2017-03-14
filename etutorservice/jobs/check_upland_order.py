# -*- coding: utf-8 -*-

import logging

from etutorservice.logic.legacy import LegacyUserManager

logger = logging.getLogger(__name__)


def _everyday_check_expired_order():
    manager = LegacyUserManager()
    manager.everyday_check_expired_order()

def run(parameter):
    _everyday_check_expired_order()
