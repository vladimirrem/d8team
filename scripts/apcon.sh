#!/usr/bin/env bash

mkdir ./config
touch ./config/$NAME.conf
sudo chmod 777 ./config/$NAME.conf

echo "<VirtualHost *:80>" >> ./config/$NAME.conf
echo "ServerAdmin webmaster@localhost" >> ./config/$NAME.conf
echo "ServerName $NAME.loc" >> ./config/$NAME.conf
echo ''  >> ./config/$NAME.conf
echo "DocumentRoot $(pwd)/html" >> ./config/$NAME.conf
echo "<Directory $(pwd)/html>" >> ./config/$NAME.conf
echo "Options Indexes FollowSymLinks MultiViews" >> ./config/$NAME.conf
echo "AllowOverride All" >> ./config/$NAME.conf
echo "Order allow,deny" >> ./config/$NAME.conf
echo "allow from all" >> ./config/$NAME.conf
echo "</Directory>" >> ./config/$NAME.conf
echo ''  >> ./config/$NAME.conf
echo ''  >> ./config/$NAME.conf
echo "ErrorLog \${APACHE_LOG_DIR}/error.log" >> ./config/$NAME.conf
echo "LogLevel warn" >> ./config/$NAME.conf
echo "CustomLog \${APACHE_LOG_DIR}/access.log combined" >> ./config/$NAME.conf
echo ''  >> ./config/$NAME.conf
echo "</VirtualHost>" >> ./config/$NAME.conf

ln -s "$(pwd)"/config/"$NAME".conf /etc/apache2/sites-enabled/"$NAME".conf
sudo chmod 777 /etc/hosts
echo "127.0.0.1  $NAME.loc" >> /etc/hosts
sudo chmod 755 /etc/hosts
sudo service apache2 restart
