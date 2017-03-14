# -*- coding: utf-8 -*-
from pysimplesoap.client import SoapClient


class MessageSender(object):

    def __init__(self):
        self.__platform = _MonGatePlatform()

    def send_message(self, phone_number, content):
        return self.__platform.send_message(phone_number, content)

    def send_same_message_bulk(self, phone_number_list, content):
        return self.__platform.send_same_message_bulk(phone_number_list, content)


class _MonGatePlatform(object):
    __url = 'http://'
    __user_id = ''
    __password = ''
    __MAX_PHONE_COUNT = 1000

    def __init__(self):
        self.__client = SoapClient(location=self.__url)

    def __invoke(self, service_name, parameters):
        parameters.update({'userId': self.__user_id, 'password': self.__password})
        return self.__client.call(service_name, **parameters)

    def send_same_message_bulk(self, phone_number_list, content):
        phone_number_list = list(set(phone_number_list))
        if not phone_number_list or not content:
            return False

        max_num = self.__MAX_PHONE_COUNT
        phone_count = len(phone_number_list)
        for index in range(0, phone_count, max_num):
            self.__send_same_bulk(phone_number_list[index:][:max_num], content)

        return True

    def __send_same_bulk(self, phone_number_list, content):
        parameters = {
            'pszMobis': ','.join(phone_number_list),
            'pszMsg': content + u'回TD退订',
            'iMobiCount': len(phone_number_list),
            'pszSubPort': '*',
            'MsgId': 112,
        }
        return self.__invoke('MongateSendSubmit', parameters)

    def send_message(self, phone_number, content):
        return self.send_same_message_bulk([phone_number], content)
