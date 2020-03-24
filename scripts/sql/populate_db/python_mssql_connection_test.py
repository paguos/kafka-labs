import pyodbc 

server = "mssql-mssql-linux-574ccb7484-9vw7k"
database = "kafka"

print(f"Connecting to db {database}...")
cnxn = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                      f"Server={server};"
                      f"Database={database}"
                      "Trusted_Connection=yes;")
print(f"Connected!")

table = "table"
print(f"Selecting random stuff form {table}...")
cursor = cnxn.cursor()
cursor.execute('SELECT * FROM Table')
print(f"Query on {table} completed!")

for row in cursor:
    print('row = %r' % (row,))
