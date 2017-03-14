# -*- coding: utf-8 -*-

import arrow
import pytest

import tests

from etutorservice.models import (
    get_current_study_year,
    get_student_grade_year,
    get_student_k12_grade,
    K12Grade,
)


def test_get_current_study_year():
    now = arrow.get('2016-01-01', 'YYYY-MM-DD')
    result = get_current_study_year(now)
    assert result == 2015
    now = arrow.get('2016-09-01', 'YYYY-MM-DD')
    result = get_current_study_year(now)
    assert result == 2016
    now = arrow.get('2016-08-31', 'YYYY-MM-DD')
    result = get_current_study_year(now)
    assert result == 2015
    now = arrow.get('2016-12-31', 'YYYY-MM-DD')
    result = get_current_study_year(now)
    assert result == 2016


def test_get_student_grade_code():
    now = arrow.get('2016-01-01', 'YYYY-MM-DD')
    result = get_student_grade_year(K12Grade.G1, now)
    assert result == 2015
    result = get_student_grade_year(K12Grade.G12, now)
    assert result == 2004
    now = arrow.get('2016-09-01', 'YYYY-MM-DD')
    result = get_student_grade_year(K12Grade.G1, now)
    assert result == 2016
    result = get_student_grade_year(K12Grade.G12, now)
    assert result == 2005
    now = arrow.get('2016-08-31', 'YYYY-MM-DD')
    result = get_student_grade_year(K12Grade.G1, now)
    assert result == 2015
    result = get_student_grade_year(K12Grade.G12, now)
    assert result == 2004


def test_get_student_k12_grade():
    now = arrow.get('2016-01-01', 'YYYY-MM-DD')
    result = get_student_k12_grade(2015, now)
    assert result == K12Grade.G1
    result = get_student_k12_grade(2016, now)
    assert result == K12Grade.G1
    result = get_student_k12_grade(2014, now)
    assert result == K12Grade.G2
    result = get_student_k12_grade(2004, now)
    assert result == K12Grade.G12
    result = get_student_k12_grade(2003, now)
    assert result == K12Grade.G12
    result = get_student_k12_grade(2005, now)
    assert result == K12Grade.G11
    now = arrow.get('2016-09-01', 'YYYY-MM-DD')
    result = get_student_k12_grade(2016, now)
    assert result == K12Grade.G1
    result = get_student_k12_grade(2017, now)
    assert result == K12Grade.G1
    result = get_student_k12_grade(2015, now)
    assert result == K12Grade.G2
    result = get_student_k12_grade(2005, now)
    assert result == K12Grade.G12
    result = get_student_k12_grade(2004, now)
    assert result == K12Grade.G12
    result = get_student_k12_grade(2006, now)
    assert result == K12Grade.G11
    now = arrow.get('2016-08-31', 'YYYY-MM-DD')
    result = get_student_k12_grade(2015, now)
    assert result == K12Grade.G1
    result = get_student_k12_grade(2016, now)
    assert result == K12Grade.G1
    result = get_student_k12_grade(2014, now)
    assert result == K12Grade.G2
    result = get_student_k12_grade(2004, now)
    assert result == K12Grade.G12
    result = get_student_k12_grade(2003, now)
    assert result == K12Grade.G12
    result = get_student_k12_grade(2005, now)
    assert result == K12Grade.G11
