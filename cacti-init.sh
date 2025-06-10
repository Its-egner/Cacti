config=/var/www/html/cacti/include/config.php

sed -i '/database_default/d' $config
sed -i '/database_hostname/d' $config
sed -i '/database_username/d' $config
sed -i '/database_password/d' $config

echo -e "
\$database_default  = '$CACTI_DB_NAME';
\$database_hostname = '$CACTI_DB_HOST';
\$database_username = '$CACTI_DB_USER';
\$database_password = '$CACTI_DB_PASS';" >> $config

echo -e "
date.timezone = $TZ
memory_limit = 512M
max_execution_time = 60
" >> /etc/php/*/apache2/php.ini

echo -e "
date.timezone = $TZ
memory_limit = 512M
max_execution_time = 60
" >> /etc/php/*/cli/php.ini

