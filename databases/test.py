import json
import os

DB_PATH = ''

# проверка корректности записей путём парсинга
for file in list(os.walk('.'))[0][2]:
    if file != 'test.py':
        try:
            json.load(open(file))
        except json.decoder.JSONDecodeError:
            print('Ошибка в', file)
print('Структура файлов проверена')


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


# принт записей в консоль
def print_(db):
    data = json.load(open(f'{DB_PATH}{db}.json'))
    for record in data:
        print(record)


# удаление записи по условию
def delete_record_from_(db, _if):
    data = json.load(open(f'{DB_PATH}{db}.json'))
    for elem in _if:
        if not(elem == 'id' and _if[elem] == 0):
            data = list(filter(lambda x: x[elem] != _if[elem], data))
        else:
            print('Запись с id = 0 не может быть удалена')
    json.dump(data, open(f'{DB_PATH}{db}.json', 'w'))


# удалить несколько записей с конца
def delete_last_records_from_(db, count=1):
    data = json.load(open(f'{DB_PATH}{db}.json'))
    if len(data) > count:
        data = data[:-count]
    else:
        data = data[:1]
    json.dump(data, open(f'{DB_PATH}{db}.json', 'w'))


# подаются 7 значений микро-плана и 7 значений плана, по одному на каждый день недели
def create_plan_on_(year, month, micro, plan):
    length = (31, 28 if year % 4 != 0 else 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    plans = json.load(open(f'{DB_PATH}plans.json'))
    new_plan = {'id': plans[-1]['id'] + 1, "month": month, "year": year}
    day = {}
    for i in range(0, length[month - 1]):
        day[str(i + 1)] = {}
        day[str(i + 1)]["micro"] = micro[i % len(micro)]
        day[str(i + 1)]["minimum"] = int(plan[i % len(plan)] * 0.8)
        day[str(i + 1)]["plan"] = plan[i % len(plan)]
        day[str(i + 1)]["overplan"] = int(plan[i % len(plan)] * 1.4)

    new_plan["day"] = day
    plans.append(new_plan)
    json.dump(plans, open(f'{DB_PATH}plans.json', 'w'))


def get_all_db_data():
    database = {}
    for file in list(os.walk('.'))[0][2]:
        if file != 'test.py':
            database[file[:-5]] = json.load(open(f'{DB_PATH}{file}'))
    return database


def find_by_id_(db, id):
    return list(filter(lambda x: x['id'] == id, json.load(open(f'{DB_PATH}{db}.json'))))[0]


def print_workshift_report_from_(year, month):
    day_name = ('пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс')
    import TableDraw as td
    from datetime import datetime
    table = td.Table('', header=['Число', 'День', 'Микро', 'Минимум', 'План', 'Сверхплан', 'Выручка', 'Сотрудники', 'Выход', 'Процент', 'Премии'])
    database = get_all_db_data()
    target_plan = list(filter(lambda x: x["month"] == month and x["year"] == year, database['plans']))[0]
    sales = list(filter(lambda x: int(x['date'].split('-')[0]) == year and int(x['date'].split('-')[1]) == month, database['sales']))
    workshifts = list(filter(lambda x: int(x['date'].split('-')[0]) == year and int(x['date'].split('-')[1]) == month, database['workshifts']))
    for day in target_plan["day"]:
        day_workshift = list(filter(lambda x: int(x['date'].split('-')[2]) == int(day), workshifts))
        day_sales = list(filter(lambda x: int(x['date'].split('-')[2]) == int(day), sales))
        money = []
        ws = []
        appearance = []
        if day_workshift:
            for worker in day_workshift[0]['workers']:
                w = find_by_id_('staff', worker['id'])
                ws.append(w['passport']['surname'] + ' ' + w['passport']['name'])
                money.append(0)
                appearance.append(worker['appearance'])
                for sale in day_sales:
                    if sale['id_staff'] == worker['id']:
                        for elem in sale['basket']:
                            product = find_by_id_(elem['type'], elem['id'])
                            money[-1] += elem['amount'] * product['price']
        plns = [target_plan["day"][day]["micro"],
                target_plan["day"][day]["minimum"],
                target_plan["day"][day]["plan"],
                target_plan["day"][day]["overplan"]]
        table.insert_row([f'{day}.{month}.{year}',
                          day_name[datetime(day=int(day), month=month, year=year).weekday()],
                          plns[0],
                          plns[1],
                          plns[2],
                          plns[3],
                          [sum(money) // len(ws) if len(ws) != 0 else 1] * len(ws) if len(ws) != 0 else 0,
                          ws,
                          appearance,
                          [0]*len(ws) if sum(money) < plns[0] else
                          [int(sum(money) * 0.07)]*len(ws) if sum(money) < plns[1] else
                          [int(sum(money) * 0.1)]*len(ws),
                          0])
    table.print_table()


def main():
    # add_record_to_('bowls', {'name': 'Глина', 'price': 350, 'description': ''})
    # add_record_to_('bowls', {'name': 'Ананас', 'price': 250, 'description': ''})
    # add_record_to_('flasks', {'name': 'Молоко', 'price': 123, 'description': ''})
    # add_record_to_('flasks', {'name': 'Виски', 'price': 321, 'description': ''})
    # add_record_to_('flasks', {'name': 'Ром', 'price': 312, 'description': ''})
    # add_record_to_('tobacco', {'name': 'Табак1', 'price': 666, 'description': ''})
    # add_record_to_('tobacco', {'name': 'Табак2', 'price': 555, 'description': ''})
    # add_record_to_('staff', {
    #     "contract": 0,
    #     "position": 0,
    #     "salary": 10000,
    #     "actual_address": "",
    #     "phone_number": "",
    #     "passport": {
    #         "series": 0,
    #         "number": 0,
    #         "issued": "yyyy-mm-dd",
    #         "photo_link": "",
    #         "surname": "Иван",
    #         "name": "Иванов",
    #         "patronymic": "Иванович",
    #         "date_of_birth": "",
    #         "sex": "",
    #         "registration_address": ""
    #     },
    #     "account": {
    #         "login": "",
    #         "password": ""
    #     }
    # }
    #               )
    # add_record_to_('staff', {
    #     "contract": 0,
    #     "position": 0,
    #     "salary": 10000,
    #     "actual_address": "",
    #     "phone_number": "",
    #     "passport": {
    #         "series": 0,
    #         "number": 0,
    #         "issued": "yyyy-mm-dd",
    #         "photo_link": "",
    #         "surname": "",
    #         "name": "Казимир",
    #         "patronymic": "Иванович",
    #         "date_of_birth": "",
    #         "sex": "",
    #         "registration_address": ""
    #     },
    #     "account": {
    #         "login": "",
    #         "password": ""
    #     }
    # }
    #                )

    # create_plan_on_(2018, 11,
    #                 [20, 20, 30, 20, 20, 20, 30],
    #                 [50, 50, 80, 50, 50, 50, 80])
    # sale_1 = [{"id": 1, "type": "bowls", "amount": 1},
    #           {"id": 2, "type": "tobacco", "amount": 1}]
    # add_record_to_('sales', {
    #             "id_staff": 1,
    #             "id_workshift": 1,
    #             "date": "2018-09-01",
    #             "time": "12:13:14",
    #             "basket": sale_1
    #             })
    # sale_2 = [{"id": 1, "type": "tobacco", "amount": 10}]
    # add_record_to_('sales', {
    #     "id_staff": 2,
    #     "id_workshift": 1,
    #     "date": "2018-09-01",
    #     "time": "12:20:06",
    #     "basket": sale_2
    # })
    print_workshift_report_from_(2018, 9)


if __name__ == '__main__':
    main()
