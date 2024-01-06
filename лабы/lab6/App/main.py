import sqlite3
from prettytable import PrettyTable

conn = sqlite3.connect('HandleSoftwareLicenses.db')
cursor = conn.cursor()
def main():
    try:
        HandleMode()
    except Exception as e:
        print("Произошла ошибка", e)
        HandleMode()

def HandleMode():
    print("""
1. Показать запись
2. Показать записи
3. Добавить запись в типы лицензий
4. Добавить запись в лицензии
5. Обновить запись в типы лицензий
6. Обновить запись в лицензии
7. Удалить запись в типы лицензий
8. Удалить запись в лицензии
9. Выход
    """)
    while True:
        mode = int(input('Введите режим работы: '))
        if mode == 1:
            ShowRecord()
        elif mode == 2:
            ShowRecords()
        elif mode == 3:
            AddTypeRecord()
        elif mode == 4:
            AddLicenseRecord()
        elif mode == 5:
            UpdateTypeRecord()
        elif mode == 6:
            UpdateLicenseRecord()
        elif mode == 7:
            DeleteTypeRecord()
        elif mode == 8:
            DeleteLicenseRecord()
        elif mode == 9:
            return


def ShowRecords():
    command = """
        Select cost_id,c.type_id,type_name,cost, effective_date 
        From License_Costs c
        JOIN License_Types t
        where c.type_id = t.type_id
    """
    cursor.execute(command)
    records = cursor.fetchall()
    th = [description[0] for description in cursor.description]
    DrawTable(th, records)
def ShowRecord():
    id = int(input("Введите cost_id: "))
    command = f"""
          Select cost_id,c.type_id,type_name,cost, effective_date 
          From License_Costs c
          JOIN License_Types t
          where c.type_id = t.type_id and c.cost_id={id}
      """
    cursor.execute(command)
    records = cursor.fetchall()
    th = [description[0] for description in cursor.description]
    DrawTable(th, records)
def AddTypeRecord():
    type_id = int(input("type_id: "))
    type_name = str(input("type_name: "))
    command = f"""
        Insert into License_Types(type_id, type_name) values({type_id},'{type_name}')
    """
    conn.execute(command)
    conn.commit()
def AddLicenseRecord():
    cost_id = int(input("cost_id: "))
    type_id = int(input("type_id: "))
    cost = float(input("cost: "))
    effective_date = str(input("effective_date: "))
    command = f"""
        INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES ({cost_id}, {type_id}, {cost},'{effective_date}');
    """
    conn.execute(command)
    conn.commit()
def DeleteLicenseRecord():
    id = int(input("Введите cost_id: "))
    command = f"""
    DELETE FROM License_Costs WHERE cost_id = {id};
    """
    cursor.execute(command)
    conn.commit()
def DeleteTypeRecord():
    id = int(input("Введите type_id: "))
    command = f"""
    DELETE FROM License_Types WHERE type_id = {id};
    """
    cursor.execute(command)
    conn.commit()
def UpdateTypeRecord():
    type_id = int(input("type_id: "))
    type_name = str(input("type_name: "))
    command = f"""
       Update License_Types set type_name = '{type_name}' where type_id = {type_id};
       """
    conn.execute(command)
    conn.commit()
def UpdateLicenseRecord():
    cost_id = int(input("cost_id: "))
    type_id = int(input("type_id: "))
    cost = float(input("cost: "))
    effective_date = str(input("effective_date: "))
    command = f"""
    Update License_Costs set type_id = {type_id} where cost_id = {cost_id};
    Update License_Costs set  cost = {cost} where cost_id = {cost_id};
    Update License_Costs set effective_date = '{effective_date}' where cost_id = {cost_id};
    """
    conn.execute(command)
    conn.commit()
def DrawTable(th,records):
    table = PrettyTable(th)
    if not records:
        print(table)
        return
    for record in records:
        table.add_row(record)
    print(table)
main()