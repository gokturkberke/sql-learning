import psycopg2 as pg2
conn = pg2.connect(database = 'testme',user='postgres',password='gbk19070')
cur = conn.cursor() # Establish connection and start cursor to be ready to query
cur.execute('SELECT * FROM users')
result =cur.fetchone() # ilk satiri yazdirir
#print(result)

result = cur.fetchmany(4) # 4 satiri yazdirir
#print(result)
#fetchall() da tum satirlari yazdirir
print(result[1][1])

# query1 = '''
#         CREATE TABLE new_table (
#             userid integer
#             , tmstmp timestamp
#             , type varchar(10)
#         );
#         '''

# cur.execute(query1)
# commit the changes to the database
# cur.commit()

conn.close() # connection kapatir

