# -*- coding: utf-8 -*-


class BaseLogic(object):
    def __init__(self, db_session):
        self.__db_session = db_session

    def _db(self):
        return self.__db_session
