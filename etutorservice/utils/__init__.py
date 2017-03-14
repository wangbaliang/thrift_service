# -*- coding: utf-8 -*-


def map_condition(condition, condition_map):
    result = {}
    for key, new_key in condition_map.iteritems():
        value = condition.get(key)
        if value is not None:
            result[new_key] = value
    return result


def map_condition_to_array(condition, condition_map):
    result = []
    for key, new_key in condition_map.iteritems():
        value = condition.get(key)
        if value is not None:
            result.append(new_key == value)
    return result
