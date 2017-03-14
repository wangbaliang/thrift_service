# -*- coding: utf-8 -*-

import datetime
import json
import arrow

from sqlalchemy import Column, func
from sqlalchemy.dialects.mysql import (
    VARCHAR, INTEGER, TINYINT, SMALLINT, DATE, TEXT, TIMESTAMP, DATETIME, TIME,
    BOOLEAN, MEDIUMINT, DECIMAL,
)

from etutorservice.common.db import ModelBase
from etutorservice.utils.config_helper import config
from etutorservice.utils.datetime_helper import format_date

__all__ = [
    'K12Grade',
    'CycleDay',
]


class EnjoyMoney(object):
    # 优惠政策倒叙最新， [{版本：1，优惠：[（总价， 满减优惠）]}],  后续政策版本向下添加
    EnjoyList = [
        {
            'version': 1,
            'money_enjoy': [
                (10000, 2000),
                ],
            'update_day': '2016-12-31'
        },
        {
            'version': 2,
            'money_enjoy': [
                (12000, 2400),
            'update_day': '2017-02-24'
        }
    ]


class AccountOpType(object):
    Buy = 1                     # 购买
    Cost = 2                    # 消费
    Makeup = 3                  # 补偿
    Expired = 4                 # 过期
    CancelApplyReturn = 5       # 约课取消退回
    ExitReturn = 6              # 取消退费
    ChangeReturn = 7            # 换课临时取消
    RefundCost = 8              # 退费扣除
    InvalidCost = 9             # 作废扣除
    InvalidReturn = 10          # 取消作废恢复


class GradeType(object):
    Primary = 0         # 小学
    JuniorHigh = 1      # 初中
    SeniorHigh = 2      # 高中

    @classmethod
    def get_grade_type(cls, k12_grade):
        if K12Grade < K12Grade.G7:
            return cls.Primary
        elif k12_grade < K12Grade.G10:
            return cls.JuniorHigh
        return cls.SeniorHigh


class K12Grade(object):
    G1 = 1          # 小学一年级
    G2 = 2          # 小学二年级
    G3 = 3          # 小学三年级
    G4 = 4          # 小学四年级
    G5 = 5          # 小学五年级
    G6 = 6          # 小学六年级
    G7 = 7          # 初中一年级
    G8 = 8          # 初中二年级
    G9 = 9          # 初中三年级
    G10 = 10        # 高中一年级
    G11 = 11        # 高中二年级
    G12 = 12        # 高中三年级
    G13 = 13        # 高中

    GRADE_CH_STR_LIST = [
        '',
        u'小一',
        u'小二',
        u'小三',
        u'小四',
        u'小五',
        u'小六',
        u'初一',
        u'初二',
        u'初三',
        u'高一',
        u'高二',
        u'高三',
        u'高中']

    @classmethod
    def to_ch_str(cls, grade):
        return cls.GRADE_CH_STR_LIST[grade]

    @classmethod
    def get_grades(cls, grade_type, subject_id, schooling_type=0):
        """
        目前仅在讲义相关逻辑时使用
        在添加已选讲义记录时，五四制传来的年级是: 6,7,8,9
        在获取已选多少套讲义时，需调用此以获取年级
        :param grade_type:
        :param subject_id:
        :param schooling_type:
        :return:
        """
        if grade_type == 2 and subject_id in [2, 4, 5]:
            return [cls.G13]
        # 六三制0 取前6个；五四制1，取前5个
        divide_num = 7 if schooling_type == 0 else 6
        if grade_type == 0:
            grades = [i for i in range(1, divide_num)]
        elif grade_type == 1:
            grades = [i for i in range(divide_num, 10)]
        elif grade_type == 2:
            grades = [i for i in range(10, 13)]
        else:
            grades = []
        return grades
