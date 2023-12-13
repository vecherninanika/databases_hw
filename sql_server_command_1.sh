docker run -d \
	--name SQLserver_db2023_14 \
	-e "ACCEPT_EULA=Y" \
	-e "MSSQL_SA_PASSWORD=password123" \
	-v ~/DATABASES/SQL_server_dont_delete/data:/var/opt/mssql/data \
	-v ~/DATABASES/SQL_server_dont_delete/log:/var/opt/mssql/log \
	-v ~/DATABASES/SQL_server_dont_delete/secrets:/var/opt/mssql/secrets \
	-p 1435:1433 \
	-d mcr.microsoft.com/mssql/server:2022-latest
