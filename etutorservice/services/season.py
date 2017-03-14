# -*- coding: utf-8 -*-

import json
import logging

from etutorservice.utils.datetime_helper import format_date
from etutorservice.utils.thrift_helper import (
    ServiceName,
    service_handler,
    service_action,
)
from etutorservice.common.db import db_session_manager as db_session_manager
from etutorservice.logic.season import SeasonManager

# from etutorservice.services.struct_translate import \
#     trans_season as _trans_season

from tutor_thrift import (
    SeasonDef,
    common as thrift_common,
)

logger = logging.getLogger(__name__)


def _trans_season(row):
    result = SeasonDef()
    result.id = row.id
    result.year = row.year
    result.seasonType = row.season_type
    result.startDay = format_date(row.start_day)
    result.endDay = format_date(row.end_day)
    result.exceptDays = [] if not row.except_days \
        else json.loads(row.except_days)
    return result


def _trans_base_season(item):
    season = SeasonDef()
    season.id = item.id
    season.year = item.year
    season.seasonType = item.season_type
    season.startDay = format_date(item.start_day)
    season.endDay = format_date(item.end_day)
    return season


@service_handler
class SeasonService(object):
    def ping(self):
        pass

    @service_action(thrift_common.ServerError)
    @ServiceName('getAll')
    def get_all(self):
        with db_session_manager.with_session() as db_session:
            manager = SeasonManager(db_session)
            data = manager.get_all()
            return [_trans_season(row) for row in data]

    @service_action(thrift_common.ServerError)
    @ServiceName('addSeason')
    def add_season(self, season):
        with db_session_manager.with_session() as db_session:
            manager = SeasonManager(db_session)
            season_id = manager.add_season(
                year=season.year, season_type=season.seasonType,
                start_day=season.startDay, end_day=season.endDay,
                except_days=season.exceptDays)
            return season_id

    @service_action(thrift_common.ServerError)
    @ServiceName('updateSeason')
    def update_season(self, season):
        with db_session_manager.with_session() as db_session:
            manager = SeasonManager(db_session)
            result = manager.update_season(
                season.id,
                year=season.year, season_type=season.seasonType,
                start_day=season.startDay, end_day=season.endDay,
                except_days=season.exceptDays)
            return result

    @service_action(thrift_common.ServerError)
    @ServiceName('deleteSeason')
    def delete_season(self, season_id):
        with db_session_manager.with_session() as db_session:
            manager = SeasonManager(db_session)
            return manager.delete_season(season_id)

    @service_action(thrift_common.ServerError)
    @ServiceName('getSeason')
    def get_season(self, season_ids):
        with db_session_manager.with_session() as db_session:
            manager = SeasonManager(db_session)
            if not season_ids:
                return []
            result = manager.get_by_ids(season_ids)
            # logger.debug('%s %s' %(season_ids, result))
            return [_trans_base_season(item) for item in result]
