# -*- coding: utf-8 -*-

import requests
import json


def post_json_data(url, data):
    response = requests.post(url, headers={'Content-Type': 'application/json'}, data=json.dumps(data))
    return True if response.status_code == 200 else False
