#!/usr/bin/env bash

echo "=== Downloading Drupal 8.2.7 ==="
wget https://ftp.drupal.org/files/projects/drupal-8.2.7.tar.gz
tar xvzf drupal-8.2.7.tar.gz
rm drupal-8.2.7.tar.gz
mv drupal-8.2.7 html
cd html
rm README.txt
rm sites/README.txt
rm modules/README.txt
rm themes/README.txt
rm sites/example.sites.php
mkdir modules/custom
mkdir modules/contrib
mkdir libraries
mkdir sites/default/files
chmod 777 -R sites/default/files
clear

echo "=== SITE SETTINGS ==="
NAME=''
while [ "$NAME" == '' ]
do
  echo "Enter project name:"
  read NAME
done
DBNAME=''
while [ "$DBNAME" == '' ]
do
  echo "Enter DB name (Will be created a new database or will be update old database):"
  read DBNAME
done
LOGIN=''
while [ "$LOGIN" == '' ]
do
  echo "Enter DB login:"
  read LOGIN
done

PASSWORD=''
while [ "$PASSWORD" == '' ]
do
  echo "Enter DB pass:"
  PASSWORD=""
  while
  read -s -n1 BUFF
  [[ -n $BUFF ]]
  do
    # 127 - backspace ascii code
    if [[ `printf "%d\n" \'$BUFF` == 127 ]]
    then
      PASSWORD="${PASSWORD%?}"
      echo -en "\b \b"
    else
      PASSWORD=$PASSWORD$BUFF
      echo -en "*"
    fi
  done
done
cp sites/default/default.settings.php sites/default/settings.php
echo "\$databases['default']['default'] = array ("  >> sites/default/settings.php
echo "  'database' => '$DBNAME'," >> sites/default/settings.php
echo "  'username' => '$LOGIN'," >> sites/default/settings.php
echo "  'password' => '$PASSWORD'," >> sites/default/settings.php
echo "  'prefix' => ''," >> sites/default/settings.php
echo "  'host' => 'localhost'," >> sites/default/settings.php
echo "  'port' => ''," >> sites/default/settings.php
echo "  'driver' => 'mysql'," >> sites/default/settings.php
echo "  'namespace' => 'Drupal\\\Core\\\Database\\\Driver\\\mysql'," >> sites/default/settings.php
echo ");" >> sites/default/settings.php

# Run composer to install drush
composer require drush/drush

# Install site via drush with admin user
drush site-install standard --account-name=admin --account-pass=admin  --site-name=$NAME --db-url=mysql://$LOGIN:$PASSWORD@localhost:/$DBNAME -y

cd ../

if [ ! -d ./config ]; then
  export NAME
  ./build/apcon.sh
fi
echo
echo "Admin login: admin"
echo "Admin pass: admin"
echo "LET\`S ROCK"
