FROM mcr.microsoft.com/mssql-tools AS base
COPY sql sql
COPY run.sh run.sh

FROM base AS init
CMD  /run.sh 1

FROM base as producer
CMD  /run.sh 2