# -*- coding: utf-8 -*-

import logging

import smtplib

from contextlib import contextmanager
from functools import wraps

from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email import encoders

from etutorservice.utils.config_helper import config
from etutorservice.utils.datetime_helper import get_now

logger = logging.getLogger(__name__)


class _SmtpManager(object):
    def __init__(self):
        self.__client = None

    @staticmethod
    def __get_mail_client():
        smtp_config = config.data['smtp']
        server_host = smtp_config['host']
        server_port = smtp_config['port']
        user_name = smtp_config['user_name']
        password = smtp_config['password']
        timeout = smtp_config.get('timeout', 30)
        client = smtplib.SMTP(server_host, server_port, timeout=timeout)
        client.starttls()
        client.login(user_name, password)
        return client

    def __is_connected(self):
        try:
            status = self.__client.noop()[0]
        except smtplib.SMTPServerDisconnected:
            status = -1
        return True if status == 250 else False

    def get_mail_client(self):
        if not self.__client or not self.__is_connected():
            self.__client = self.__get_mail_client()
        return self.__client


smtp_manager = _SmtpManager()


class MailSender(object):
    def __init__(self):
        self.__client = None

    def send_email(self, to_addresses, title, content, from_address=None,
                   content_type='html', charset='utf-8', files=None):
        """
        发送邮件
        :param to_addresses: 收件人邮箱，以;分隔
        :param title: 邮件主题
        :param content: 邮件正文
        :param content_type:
        :param charset:
        :param from_address
        :param files: 文件名/文件夹名(皆可)列表
        :return:
        """
        self.__client = smtp_manager.get_mail_client()
        if not from_address:
            from_address = config.data['smtp']['user_name']

        if files:
            message = self.__attach_file(files)
            message.attach(MIMEText(content, _subtype=content_type,
                                    _charset=charset))
        else:
            message = MIMEText(content, _subtype=content_type, _charset=charset)

        message['Subject'] = title
        message['From'] = from_address
        message['To'] = ';'.join(to_addresses)
        self.__client.sendmail(from_address, to_addresses, message.as_string())

    @staticmethod
    def __attach_file(virtual_file, file_name=None):
        if not file_name:
            file_name = get_now().format('YYYY-MM-DD') + '.csv'
        message = MIMEMultipart()
        msg = MIMEBase('application', 'octet-stream')
        msg.set_payload(virtual_file.getvalue())
        encoders.encode_base64(msg)
        msg.add_header('Content-Disposition', 'attachment', filename=file_name)
        message.attach(msg)
        return message
