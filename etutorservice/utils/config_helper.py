# -*- coding: utf-8 -*-

import yaml


class _Config(object):
    __config = None

    def load_config_file(self, path):
        with open(path, 'r') as f:
            self.__config = yaml.safe_load(f)

    @property
    def data(self):
        return self.__config

    def get(self, accessor_string, default_val=None):
        current_data = self.__config
        paths = accessor_string.split('.')
        for chunk in paths:
            if current_data and chunk in current_data:
                current_data = current_data[chunk]
            else:
                return default_val
        return current_data


config = _Config()
