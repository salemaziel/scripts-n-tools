#/bin/bash

if [ "$(whoami)" != 'root' ]; then
    echo $"You have no permission to run $0 as non-root user. Please use sudo"
        exit 1;
fi


umask 077
apt-get update && apt-get install --reinstall postfix libsasl2-modules -y
nano /etc/postfix/main.cf
nano /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd*
ll /etc/postfix/
/etc/init.d/postfix restart
apt-get install mailutils -y
echo 'Test passed.' | mail -s 'Test-Email' mymainemail0501@gmail.com
tail -n 20 /var/log/syslog

