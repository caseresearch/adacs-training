#!/bin/bash
service mysql start
mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED BY 'some_pass';GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';"
mysql -psome_pass < employees.sql
