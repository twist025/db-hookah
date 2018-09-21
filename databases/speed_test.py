import os
import json
from datetime import datetime
import time
from config import *


def find_by_id_(db, value):
    try:
        return list(filter(lambda x: x['id'] == value, json.load(open(f'{DB_PATH}{db}.json'))))[0]
    except IndexError:
        return {}


def find_by_id_clone_(db, value):
    try:
        return next(filter(lambda x: x['id'] == value, json.load(open(f'{DB_PATH}{db}.json'))))
    except StopIteration:
        return {}


def find_by_id_evil_clone_(db, value):
    data = json.load(open(f'{DB_PATH}{db}.json'))
    for record in data:
        if record['id'] == value:
            return record
    return {}


iters = 10000

a = find_by_id_('sales', 1)
c = find_by_id_clone_('sales', 1)
b = find_by_id_evil_clone_('sales', 1)


print(a)
print(c)
print(b)
print(a == b == c)

now = time.time()
for i in range(iters):
    a = find_by_id_('sales',  1)
print(time.time() - now)

now = time.time()
for i in range(iters):
    a = find_by_id_clone_('sales',  1)
print(time.time() - now)

now = time.time()
for i in range(iters):
    b = find_by_id_evil_clone_('sales', 1)
print(time.time() - now)
