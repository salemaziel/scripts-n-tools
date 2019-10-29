#!/bin/env bash

echo "Before running this script, please upload infiniteWP zip file to bitnami's home folder at /home/bitnami or it won't work correctly"

read -p "Have you done so?[y/n] " upload_answer
if test $upload_answer == "n"; then
    echo "Please upload it then run the script again"
    exit 1
fi

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

read -p "Enter new database name: " db_name
read -p "Enter desired database username: " db_user
read -p "Enter desired database password for new database user: " db_passwd
read -p "Change roots database password?Default is: bitnami [y/n] " change_rtpw

mkdir /opt/bitnami/apps/iwp/conf
mkdir /opt/bitnami/apps/iwp/htdocs
unzip IWPAdminPanel_v*.zip -d /opt/bitnami/apps/
mv /opt/bitnami/apps/iwp/IWPAdminPanel_v* /opt/bitnami/apps/iwp/htdocs 

/opt/bitnami/ctlscript.sh stop
/opt/bitnami/ctlscript.sh status
sleep 5

if test $change_rtpw == "y"; then
    touch /home/bitnami/mysql-init
    read -p "Enter new root database password: " root_dbpw
        echo "UPDATE mysql.user SET authentication_string=PASSWORD('$root_dbpw') WHERE User='root';" >> /home/bitnami/mysql-init
        echo "FLUSH PRIVILEGES;" >> /home/bitnami/mysql-init
fi

echo **********************************************************************************
echo " If following command doesnt exit and continue on its own, manually enter: disown; "
echo ***********************************************************************************
sleep 2

/opt/bitnami/mysql/bin/mysqld_safe --pid-file=/opt/bitnami/mysql/data/mysqld.pid --datadir=/opt/bitnami/mysql/data --init-file=/home/bitnami/mysql-init 2> /dev/null &

/opt/bitnami/ctlscript.sh restart mysql
/opt/bitnami/ctlscript.sh status mysql
sleep 3



/opt/bitnami/mysql/bin/mysql -u root -p$root_dbpw -e "CREATE DATABASE '${db_name}' /*\!40100 DEFAULT CHARACTER SET utf8 */;"
/opt/bitnami/mysql/bin/mysql -u root -p$root_dbpw -e "CREATE USER '${db_user}'@'%' IDENTIFIED BY '${db_passwd}';"
/opt/bitnami/mysql/bin/mysql -u root -p$root_dbpw -e "GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost';"
/opt/bitnami/mysql/bin/mysql -u root -p$root_dbpw -e "FLUSH PRIVILEGES;"


touch /opt/bitnami/apps/iwp/conf/httpd-prefix.conf
echo '
Alias /iwp/ "/opt/bitnami/apps/iwp/htdocs/"
Alias /iwp "/opt/bitnami/apps/iwp/htdocs/"

Include "/opt/bitnami/apps/iwp/conf/httpd-app.conf' >> /opt/bitnami/apps/iwp/conf/httpd-prefix.conf

touch /opt/bitnami/apps/iwp/conf/httpd-app.conf
echo -e "<Directory /opt/bitnami/apps/iwp/htdocs/>
    Options +FollowSymLinks
    AllowOverride None
    <IfVersion < 2.3 >
    Order allow,deny
    Allow from all
    </IfVersion>
    <IfVersion >= 2.3>
    Require all granted
    </IfVersion>
</Directory> " >> /opt/bitnami/apps/iwp/conf/httpd-app.conf

echo -e 'Include "/opt/bitnami/apps/iwp/conf/httpd-prefix.conf"' >> /opt/bitnami/apache2/conf/bitnami/bitnami-apps-prefix.conf 

/opt/bitnami/ctlscript.sh stop
sleep 5
/opt/bitnami/ctlscript.sh start

/opt/bitnami/ctlscript.sh status

touch /opt/bitnami/apps/iwp/htdocs/config.php
chmod 666 /opt/bitnami/apps/iwp/htdocs/config.php
find /opt/bitnami/apps/iwp/htdocs -type d -exec chmod 755 {} \;
find /opt/bitnami/apps/iwp/htdocs -type f -exec chmod 644 {} \;
chown -R daemon:daemon /opt/bitnami/apps/iwp/htdocs
chmod 666 /opt/bitnami/apps/iwp/htdocs/config.php

echo *********************************************************
echo      Core installation of InfiniteWP completed!          
echo  Check http://ipaddress/iwp
echo *********************************************************
