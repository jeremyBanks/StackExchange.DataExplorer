#!/bin/bash -eux
SQL_SERVER_IMAGE='registry.hub.docker.com/microsoft/mssql-server-linux:latest';
SQL_SERVER_CONTAINER='sede-sql-server';
SQL_SERVER_PORT=1433

docker pull "$SQL_SERVER_IMAGE";
docker run \
    -e 'ACCEPT_EULA=Y' \
    -e 'SA_PASSWORD=Password1' \
    -p "127.0.0.1:1433:$SQL_SERVER_PORT" \
    --name "$SQL_SERVER_CONTAINER" \
    -d='true' \
    "$SQL_SERVER_IMAGE";

(
    cd 'App/StackExchange.DataExplorer/';
    dotnet run;
) || (
    echo "An error ocurred (exit status $?).";
);

docker stop "$SQL_SERVER_CONTAINER";
docker rm "$SQL_SERVER_CONTAINER";
