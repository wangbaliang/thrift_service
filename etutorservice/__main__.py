# -*- coding: utf-8 -*-

import importlib
import argparse
import logging
import sys

from etutorservice.utils.config_helper import config
from etutorservice.utils.thrift_helper import create_multiplexed_server
from etutorservice.common.db import (
    db_session_manager as session_manager,
    redis_manager,
)


def _parse_args():
    parser = argparse.ArgumentParser('run tutor service or commands')
    parser.add_argument('-c', '--config', dest='config_file', required=True,
                        help='config file path')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-r', '--runservice', action='store_true',
                       dest='run_service')
    group.add_argument('-e', '--exec', dest='command_name',
                       help='exec command name')
    parser.add_argument('command_args', nargs='*',
                        help='sub command args')
    return parser.parse_args()


def _start_thrift_service():
    import thriftpy
    tutor_thrift = thriftpy.load('thriftfiles/tutor.thrift', 'tutor_thrift',
                                 include_dirs=['thriftfiles'])
    tutor_urge_thrift = thriftpy.load('thriftfiles/tutor_urge.thrift',
                                      'tutor_urge_thrift',
                                      include_dirs=['thriftfiles'])

    from etutorservice.services.season import SeasonService
    from etutorservice.services.period import PeriodService
    from etutorservice.services.class_template import ClassTemplateService
    from etutorservice.services.coach import CoachService
    from etutorservice.services.student import StudentService
    from etutorservice.services.quota import QuotaService
    from etutorservice.services.tutor_client import TutorClientService
    from etutorservice.services.class_admin import ClassAdminService
    from etutorservice.services.class_service import ClassService
    from etutorservice.services.coach_client import CoachClientService
    from etutorservice.services.monitor import MonitorService
    from etutorservice.services.urge_class import UrgeClassService
    from etutorservice.services.sms_code import SmsCodeService
    from etutorservice.services.experience_center import ExperienceService
    from etutorservice.services.payment import PaymentService

    thrift_config = config.data['thrift_service']['tutor']
    server = create_multiplexed_server(
        [
            (tutor_thrift.SeasonService, SeasonService(), 'season_service'),
            (tutor_thrift.PeriodService, PeriodService(), 'period_service'),
            (tutor_thrift.ClassTemplateService, ClassTemplateService(), 'class_template_service'),
            (tutor_thrift.CoachService, CoachService(), 'coach_service'),
            (tutor_thrift.StudentService, StudentService(), 'student_service'),
            (tutor_thrift.ClassAdminService, ClassAdminService(), 'class_admin_service'),
            (tutor_thrift.ClassService, ClassService(), 'class_service'),
            (tutor_thrift.QuotaService, QuotaService(), 'quota_service'),
            (tutor_thrift.TutorClientService, TutorClientService(), 'tutor_client_service'),
            (tutor_thrift.CoachClientService, CoachClientService(), 'coach_client_service'),
            (tutor_thrift.MonitorService, MonitorService(), 'monitor_service'),
            (tutor_thrift.SmsCodeService, SmsCodeService(), 'sms_code_service'),
            (tutor_thrift.PaymentService, PaymentService(), 'payment_service'),
            (tutor_urge_thrift.UrgeClassService, UrgeClassService(), 'urge_class_service'),
            (tutor_thrift.ExperienceService, ExperienceService(), 'experience_service'),
        ], thrift_config)
    server.serve()


def _run_sub_command(command_name, command_args):
    try:
        command_module = importlib.import_module(
            'etutorservice.jobs.%s' % command_name)
        command_module.run(command_args)
    except ImportError as e:
        print('the command %s not found' % e.message)


def _init_logging_setting():
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    ch = logging.StreamHandler(sys.stdout)
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    logger.addHandler(ch)
    return logger


def main():
    logger = _init_logging_setting()

    args = _parse_args()

    config.load_config_file(args.config_file)

    session_manager.register_db(config.data['mysql_db']['tutor'], 'default')
    redis_manager.register_db(config.data['redis_db'], config.data['redis_server'])

    if args.run_service:
        logger.info('service start')
        _start_thrift_service()
    elif args.command_name:
        logger.info('command start')
        _run_sub_command(args.command_name, args.command_args)
    else:
        print('args not valid')


if __name__ == '__main__':
    main()
