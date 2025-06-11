echo "Enter mysql Root Password for Setting up Database"
read -p "Enter Root Password: " mysqlroot

mysql -h $CACTI_DB_HOST -uroot -p$mysqlroot -e "GRANT SELECT ON mysql.time_zone_name TO $CACTI_DB_USER"

mysql -h $CACTI_DB_HOST -uroot -p$mysqlroot $CACTI_DB_NAME < /var/www/html/cacti/cacti.sql

mysql -h $CACTI_DB_HOST -u root -p$mysqlroot mysql < /var/www/html/cacti/timezone.sql
