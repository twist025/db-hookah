import json
import os

# проверка корректности записей путём парсинга
for file in list(os.walk('.'))[0][2]:
    if file != 'test.py':
        try:
            json.load(open(file))
        except json.decoder.JSONDecodeError:
            print('Ошибка в', file)
print('Структура файлов проверена')


# добавить запись в бд db
def add_record_to_(db, record: dict):
    data = json.load(open(f'{db}.json'))
    record['id'] = data[-1]['id'] + 1
    if set(data[0]) - set(record) != set():
        print('Предупреждение: структура отличается')
    data.append(record)
    json.dump(data, open(f'{db}.json', 'w'))


# принт записей в консоль
def print_(db):
    data = json.load(open(f'{db}.json'))
    for record in data:
        print(record)


# удаление записи по условию
def delete_record_from_(db, _if):
    data = json.load(open(f'{db}.json'))
    for elem in _if:
        if not(elem == 'id' and _if[elem] == 0):
            data = list(filter(lambda x: x[elem] != _if[elem], data))
        else:
            print('Запись с id = 0 не может быть удалена')
    json.dump(data, open(f'{db}.json', 'w'))


def main():
    record = {'name': 'Глина', 'price': 350, 'description': 'Чаша из глины'}
    add_record_to_('bowls', record)
    print_('bowls')
    # delete_record_from_('bowls', _if={'id': 1})


if __name__ == '__main__':
    main()
