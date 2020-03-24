#! /bin/bash
export PWD="MyStrongPassword1234"
if [ "$1" = "1" ]; then
    /opt/mssql-tools/bin/sqlcmd -S mssql-mssql-linux.kafka,1433 -U sa -P $PWD -i /sql/seed.sql
elif [ "$1" = "2" ]; then
    end=$((SECONDS+3600))
    while [[ $SECONDS -lt $end ]]; do
        /opt/mssql-tools/bin/sqlcmd -S mssql-mssql-linux.kafka,1433 -U sa -P $PWD -i /sql/insert.sql
        # echo "Every second ..."
        sleep 1
        :
    done
else
    echo "Invalid argument"
fi