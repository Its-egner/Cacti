#!/bin/bash

config=/var/www/html/cacti/include/config.php
sconfig=/usr/local/spine/etc/spine.conf

sed -i '/database_default/d' $config
sed -i '/database_hostname/d' $config
sed -i '/database_username/d' $config
sed -i '/database_password/d' $config

sed -i '/DB_Database/d' $sconfig
sed -i '/DB_Host/d' $sconfig
sed -i '/DB_User/d' $sconfig
sed -i '/DB_Pass/d' $sconfig
sed -i '/Cacti_Log/d' $sconfig

echo -e "
\$database_default  = '$CACTI_DB_NAME';
\$database_hostname = '$CACTI_DB_HOST';
\$database_username = '$CACTI_DB_USER';
\$database_password = '$CACTI_DB_PASS';" >> $config

echo -e "
Cacti_Log     /var/www/html/cacti/log/cacti.log
DB_Database	$CACTI_DB_NAME
DB_Host	$CACTI_DB_HOST
DB_User	$CACTI_DB_USER
DB_Pass	$CACTI_DB_PASS" >> $sconfig

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

grepport70=$(grep -c 7070 /etc/apache2/ports.conf)
if [ $grepport70 -eq "0" ]; then
     sed -i 's/Listen 80/Listen 80\nListen 7070/g' /etc/apache2/ports.conf
fi

if [ ! -f /root/cert.pem ]; then
     openssl req -x509 -newkey rsa:4096 -keyout /root/key.pem -out /root/cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=State/L=City/O=Company/OU=CompanySection/CN=Cacti"
fi

while pgrep -u root openssl > /dev/null; do sleep 1; echo "Openssl still running"; done
