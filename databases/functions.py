import json
import os
from config import *


# хэш MD5
def get_hash_from_(text):
    import hashlib
    return hashlib.md5(text.encode()).hexdigest()


# достать все данные из бд, кроме 1 записи
def get_data_from_(db):
    return json.load(open(f'{DB_PATH}{db}.json'))[1:]


# добавить запись в бд db
def add_record_to_(db, record: dict):
    data = json.load(open(f'{DB_PATH}{db}.json'))
    record['id'] = data[-1]['id'] + 1
    if set(data[0]) - set(record) != set():
        print('Предупреждение: структура отличается')
    data.append(record)
    json.dump(data, open(f'{DB_PATH}{db}.json', 'w'))


# поиск в бд по id
def find_by_id_(db, value):
    try:
        return list(filter(lambda x: x['id'] == value, json.load(open(f'{DB_PATH}{db}.json'))))[0]
    except IndexError:
        return {}


def find_by_id_evil_clone_(db, value):
    data = json.load(open(f'{DB_PATH}{db}.json'))
    for record in data:
        if record['id'] == value:
            return record
    return {}


def find_by_key_(db, key, value):
    return list(filter(lambda x: x[key] == value, json.load(open(f'{DB_PATH}{db}.json'))))


def find_by_key_evil_clone_(db, key, value):
    return [record for record in json.load(open(f'{DB_PATH}{db}.json')) if record[key] == value]
