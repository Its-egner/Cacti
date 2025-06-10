echo "Enter mysql Root Password for Setting up Database"
read -p "Enter Root Password: " mysqlroot

echo mysql -h $CACTI_DB_HOST -uroot -p$mysqlroot -e 'GRANT SELECT ON mysql.time_zone_name TO $CACTI_DB_NAME'

echo mysql -h $CACTI_DB_HOST -uroot -p$mysqlroot $CACTI_DB_NAME < /var/www/html/cacti/cacti.sql
