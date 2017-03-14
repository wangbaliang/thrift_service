# -*- coding: utf-8 -*-

import pytest
import json
from datetime import time
from tests import thrift_service, config, tutor_thrift
from etutorservice.utils.thrift_helper import ThriftClient


@pytest.fixture(scope='class')
def thrift_client(request):
    client = ThriftClient(
        tutor_thrift.ClassService,
        config.data['thrift_service']['tutor'],
        'class_service'
    )
    request.cls.client = client


@pytest.mark.usefixtures('thrift_service', 'thrift_client')
class TestClassService(object):

    def test_update_rank_class_num(self):
        data = json.dumps([{'id': 1, 'spring_max_num': 10, 'spring_base_num': 2}])
        self.client.updateRankClassNum(data)
