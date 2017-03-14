# -*- coding: utf-8 -*-

import logging

from etutorservice.common.db import db_session_manager
from etutorservice.logic.business import SaleCardManager

logger = logging.getLogger(__name__)


def _add_sale_cards():
    with db_session_manager.with_session() as db_session:
        manager = SaleCardManager(db_session)
        manager.everyday_add_sale_cards()

def run(parameter):
    _add_sale_cards()
