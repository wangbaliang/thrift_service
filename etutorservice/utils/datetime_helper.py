# -*- coding: utf-8 -*-

import arrow

from datetime import time, datetime


def format_date(date_info, date_format='YYYY-MM-DD', tz=None):
    result = arrow.get(date_info)
    if tz:
        result = result.to(tz)
    return result.format(date_format)


def to_timestamp(date_info, tz=None):
    if tz:
        return arrow.get(date_info).replace(tzinfo=tz).timestamp
    return arrow.get(date_info).timestamp


def period_time_to_int(time_info):
    return time_info.hour * 60 + time_info.minute


def period_int_to_time(period_time):
    hour = period_time / 60
    minute = period_time % 60
    return time(hour=hour, minute=minute)


def format_time(time_obj, time_format='%H:%M:%S'):
    return time_obj.strftime(time_format)


def parse_time(time_text, time_format='%H:%M'):
    return datetime.strptime(time_text, time_format).time()


def get_now(tz='+08:00'):
    return arrow.now(tz)


def combine(date_info, time_info):
    return datetime.combine(date_info, time_info)


def to_date(date_text, tz=None):
    result = arrow.get(date_text)
    if tz:
        result = result.to(tz)
    return result.date()


def to_datetime(datetime_text, tz=None):
    result = arrow.get(datetime_text)
    if tz:
        result = result.to(tz)
    return result
