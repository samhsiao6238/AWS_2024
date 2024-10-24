import pymysql

db_settings = {
    "host": "database20230727.cor4lwuuxkis.us-east-1.rds.amazonaws.com",
    "port": 3306,
    "user": "admin",
    "password": "<資料庫密碼>",
    "db": "db20270727",
    "charset": "utf8"
}
try:
    # 建立Connection物件
    
    conn=pymysql.connect(**db_settings)
    
except Exception as ex:
    print(ex)
Platform='OBS'
Synchronize='99'
Asyn='98'
Hybrid='92'

with conn.cursor() as cursor:
        # 查詢資料SQL語法
        command = "INSERT INTO ch8 ( `Platform`, `Synchronize`, `Asyn`, `Hybrid`) VALUES ( '"+Platform+"', '"+Synchronize+"', '"+Asyn+"',' "+Hybrid+"')"
#       command = "INSERT INTO pannel ( `Date`, `Time`, `Lon`, `Lat`, `Alt`) VALUES ( %s, %s, %s, %s, %s);"
         # 執行指令
        cursor.execute(command)
        # 取得所有資料
        result = cursor.fetchall()
        print(result)
        conn.commit()
with conn.cursor() as cursor:
        # 查詢資料SQL語法
        command = "SELECT * FROM ch8"
        # 執行指令
        cursor.execute(command)
        # 取得所有資料
        result = cursor.fetchall()
        print(result)
        for row in result:
            print(row[2])
        print('result')
        print(result[1][3])
#     
conn.close()