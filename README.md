# Cacti
### Cacti Monitoring Docker Container

For help visit me at http://forum.its-egner.de

At first clone Repo and change Directory 

```
git clone https://github.com/Its-egner/Cacti.git
cd Cacti
```

Edit docker-compose File, change Passwords! and bring Container up.
```
docker compose up -d
```
Container will build and start

Chown the Files to
```
chown 33:33 cacti_log/ cacti_plugins/ cacti_rra/
```
Do Database initialisation with
```
docker exec -ti cacti_app bash /var/www/html/init-db.sh
```
visit cacti <your_IP>:7070/cacti

If prompt for Login use admin admin

If you want to use Spine, enter config Path

/usr/local/spine/etc/spine.conf
