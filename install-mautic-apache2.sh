#!/bin/bash

if [ "$(whoami)" != 'root' ]; then
    echo $"You have no permission to run $0 as non-root user. Please use sudo"
        exit 1;
fi


echo "*********************************************"
echo           " Setting Configurations "
echo "*********************************************"
sleep 2

read -p "Database Password: " db_passwd
read -p "Database Name: " name_4_db
read -p "Database Username: " db_username
read -p "Full Domain Name to install to: " install_domain
read -p "Email address: " email_address 

echo "*********************************************"
echo " These are the Configurations you entered: "
echo "*********************************************"
echo "DB pass is '$db_passwd' "
echo "db name is '$name_4_db' "
echo "db username is '$db_username' "
echo "domain is '$install_domain' "
echo "email address is '$email_address' "
sleep 2
read -p "Are these correct?[y/n] " correct_confs
if test $correct_confs == "n"; then
    echo "Please run the script again and enter the correct configurations"
        exit 1;
fi


#Variables
pass=($db_passwd)
db_name=($name_4_db)
db_user=($db_username)
web_root='/var/www/html/mautic'
domain=($install_domain)
email=($email_address)
timezone='America/Los_Angeles'

### Set default parameters

sitesEnabled='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
sitesAvailabledomain=$sitesAvailable$domain.conf
export DEBIAN_FRONTEND=noninteractive
#####


#Ensure it only works on ubuntu and install apps for specific versions
if [  -n "$(uname -a | grep Ubuntu)" ]; then
        echo `lsb_release -d | grep -oh Ubuntu.*`

        echo " ** Updating the repository with Certbot ** "
        add-apt-repository -y ppa:certbot/certbot
        apt-get update
        echo " ** Installing LAMP packages **"
        apt-get --assume-yes install apache2 mysql-server php php-cli libapache2-mod-php php-mysql unzip python-certbot-apache
        apt-get --assume-yes install php-zip php-xml php-imap php-opcache php-apcu php-memcached php-mbstring php-curl php-amqplib php-mbstring php-bcmath php-intl


        x=`lsb_release -rs`
        if (($(echo "$x < 18.04" | bc -l) ));then
                echo "old version"
                apt-get --assume-yes install php-mcrypt
        fi
else
        echo " ** This script is Ubuntu specific. Quitting ** "
        exit 1
fi
cd /etc/apache2/mods-enabled/
sed -e 's/\s*DirectoryIndex.*$/\tDirectoryIndex index\.php index\.html index\.cgi index\.pl index\.xhtml index\.htm/' \
    dir.conf > /tmp/dir.conf && mv /tmp/dir.conf dir.conf
systemctl restart apache2

while true; do
    read -p "Do you wish to secure your mysql installation? Y/N: " yn
    case $yn in
        [Yy]* ) mysql_secure_installation; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

mysql -e "DROP DATABASE IF EXISTS ${db_name};"
mysql -e "CREATE DATABASE ${db_name} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -e "DROP USER IF EXISTS ${db_user}@localhost;"
mysql -e "CREATE USER ${db_user}@localhost IDENTIFIED BY '${pass}';"
mysql -e "GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

cd

curl -s https://api.github.com/repos/mautic/mautic/releases/latest \
| grep "browser_download_url.*zip" \
| cut -d : -f 2,3 \
| tr -d \" \
| tail -1 | wget -O mautic.zip -qi -

unzip -o mautic.zip -d $web_root
#rm mautic.zip

apacheUser=$(ps -ef | egrep '(httpd|apache2|apache)' | grep -v root | head -n1 | awk '{print $1}')
# Set permissions for apache
cd $web_root
chown -R $apacheUser:$apacheUser .
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chmod -R g+w app/cache/
chmod -R g+w app/logs/
chmod -R g+w app/config/
chmod -R g+w media/files/
chmod -R g+w media/images/
chmod -R g+w translations/

### check if domain already exists
if [ -e $sitesAvailabledomain ]; then
    echo -e "This domain already exists.\nRemoving...."

    ### disable website
    a2dissite $domain

    ### restart Apache
    /etc/init.d/apache2 reload

    ### Delete virtual host rules files
    rm $sitesAvailabledomain
    ### show the finished message
    echo -e "Complete!\nVirtual Host $domain has been removed."
fi

### create virtual host rules file
if ! echo "
<VirtualHost *:80>
    ServerAdmin $email
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot $web_root
    <Directory />
        AllowOverride All
    </Directory>
    <Directory $web_root>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
        Require all granted
    </Directory>
    ErrorLog /var/log/apache2/$domain-error.log
    LogLevel error
    CustomLog /var/log/apache2/$domain-access.log combined
</VirtualHost>" > $sitesAvailabledomain
then
    echo -e $"There is an ERROR creating $domain file"
    exit;
else
    echo -e $"\nNew Virtual Host Created\n"
fi

### enable website
a2ensite $domain

ini=$(sudo find /etc/ -name php.ini | grep 'apache2')
sed 's#^;*date\.timezone[[:space:]]=.*$#date.timezone = "'"$timezone"'"#' $ini > /tmp/timezone.conf && mv /tmp/timezone.conf $ini

### restart Apache
/etc/init.d/apache2 reload

#Setup SSL for https
certbot -d $domain --non-interactive --redirect --keep-until-expiring --agree-tos --apache -m $email

(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:segments:update > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:campaigns:trigger > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:campaigns:rebuild > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:iplookup:download > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:emails:send > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:email:fetch > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:social:monitoring > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:webhooks:process > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:broadcasts:send > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:import > /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * www-data /usr/bin/php /var/www/mautic/app/console mautic:campaigns:process_resets > /dev/null 2>&1") | crontab -

### Finished
echo -e $"Done! \nYou have a new Mautic install on a virtual host \nYour new host is: https://$domain \nAnd its path and location is $web_root"
