# -*- coding: utf-8 -*-

import pytest
import subprocess
import shlex
import time
import thriftpy

from etutorservice.utils.config_helper import config
from etutorservice.common.db import db_session_manager as session_manager, redis_manager

tutor_thrift = thriftpy.load('thriftfiles/tutor.thrift', 'tutor_thrift',
                             include_dirs=['thriftfiles'])
tutor_urge_thrift = thriftpy.load('thriftfiles/tutor_urge.thrift',
                                  'tutor_urge_thrift',
                                  include_dirs=['thriftfiles'])

_CONFIG_PATH = 'etc/test.yml'

config.load_config_file(_CONFIG_PATH)

session_manager.register_db(config.data['mysql_db']['tutor'], 'default')

redis_manager.register_db(config.data['redis_db'], config.data['redis_server'])


def _start_service(cmd):
    args = shlex.split(cmd)
    p = subprocess.Popen(args)
    time.sleep(1)
    return p


def start_thrift_service():
    cmd = 'python -m etutorservice --config %s -r' % _CONFIG_PATH
    return _start_service(cmd)


@pytest.fixture()
def database_session(request):
    session = session_manager.get_session()

    def _close_database():
        session.close()
    request.addfinalizer(_close_database)

    return session


@pytest.fixture(scope='class')
def thrift_service(request):
    server = start_thrift_service()

    def _stop_server():
        server.kill()
    request.addfinalizer(_stop_server)
