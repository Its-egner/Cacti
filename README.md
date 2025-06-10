# Cacti
Cacti Monitoring Docker Container

For help visit me at http://forum.its-egner.de

At first do 

git clone https://github.com/Its-egner/Cacti.git

cd Cacti

Edit docker-compose File, change Passwords!

do docker compose up -d

Container will build and start

Do Database initialisation with

docker exec -ti cacti_app init-db.sh

Import Timezone File to Database

docker exec -ti cacti_db bash

mysql -u root -proot_password mysql < /usr/share/mysql/mysql_test_data_timezone.sql

visit cacti <your_IP>:7070/cacti
