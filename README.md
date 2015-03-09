# Nginx-HHVM-With-PHP5-FPM-Failover---MariaDB
This installer will give you nginx running HHVM with PHP5-FPM Failover & MariaDB.
Monit will be installed to monitor if HHVM goes down, and restart it.

After installer.sh is completed.
Edit /etc/monit//monitrc/hhvm-monit and replace "domain.tld" with your domain.
Edit /etc/nginx/sites-enabled/standard and replace domain.tld for the vhost.
Run: sudo apt-get install mariadb-server
