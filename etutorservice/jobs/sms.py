# -*- coding: utf-8 -*-

import logging

from etutorservice.common.db import db_session_manager
from etutorservice.logic.sms import SmsMessageManager
from etutorservice.utils.sms_helper import MessageSender

logger = logging.getLogger(__name__)


def run(parameter):
    if len(parameter) < 1:
        print('parameter not valid')
        return

    action = parameter[0]

    if action == 'send':
        _send_sms()


def _send_sms():
    logger.info('start send sms.')

    with db_session_manager.with_session() as db_session:
        sender = MessageSender()
        manager = SmsMessageManager(db_session)
        sms_list = manager.get_need_send_sms()
        for sms in sms_list:
            sender.send_same_message_bulk(sms.get_phone_numbers(), sms.content)
            manager.set_sms_is_send([sms.id])

    logger.info('send sms end.')
