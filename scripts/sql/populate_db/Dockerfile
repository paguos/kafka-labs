FROM alpine:3.4
WORKDIR /usr/src/app

COPY install_microsoft_driver_for_sql_server.sh .
COPY python_mssql_connection_test.py .

RUN apk update

RUN apk add --update-cache \
    python 
RUN apk add --update py-pip
RUN apk add
RUN pip install pyodbc 

CMD ["chmod", "+x", "install_microsoft_driver_for_sql_server.sh"]
CMD ["./install_microsoft_driver_for_sql_server.sh"]
CMD ["python3", "run", "python_mssql_connection_test.py"]

