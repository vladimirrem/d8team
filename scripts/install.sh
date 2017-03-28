#!/usr/bin/env bash

set -e
# Download Drupal from Drupal.org and extract
echo "Drupal 8 version to install? Type (8.x.x):"
read ver
wget https://ftp.drupal.org/files/projects/drupal-$ver.tar.gz
while [ ! -f drupal-$ver.tar.gz ]
do
  unset ver
  echo "Oops, wrong version! Try again (8.x.x):"
  read ver
  wget https://ftp.drupal.org/files/projects/drupal-$ver.tar.gz
done
tar xvzf drupal-$ver.tar.gz
rm drupal-$ver.tar.gz
mv drupal-$ver html
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
cp ../composer.json ./composer.json
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

# Run composer to install required packages
composer update

# Install site with admin user and enable modules via drush
./vendor/bin/drush site-install standard --account-name=admin --account-pass=admin  --site-name=$NAME --db-url=mysql://$LOGIN:$PASSWORD@localhost:/$DBNAME -y
./vendor/bin/drush en -y admin_toolbar admin_toolbar_tools

cd ../

if [ ! -d ./config ]; then
  export NAME
  ./scripts/apcon.sh
fi
echo
echo "Admin login: admin"
echo "Admin pass: admin"
echo "LET\`S ROCK"
