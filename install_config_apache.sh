#!/bin/bash

echo "install apache2 script"

SECURITY_CONF="/etc/apache2/conf-enabled/security.conf"
DIR_CONF="/etc/apache2/mods-enabled/dir.conf"
APACHE2_CONF="/etc/apache2/apache2.conf"
DEFAULT_000="/etc/apache2/sites-enabled/000-default.conf"

apt -y install apache2

chmod +x ./backup-script.sh

./backup-script.sh

chmod +x $SECURITY_CONF $APACHE2_CONF $DIR_CONF $DEFAULT_000

cat > $SECURITY_CONF <<EOF
ServerTokens Prod
ServerSignature On
TraceEnable Off
EOF

cat > $DIR_CONF <<EOF
<IfModule mod_dir.c>
        DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
</IfModule>
EOF


echo -n "Type server name: "

read SERVER_NAME
cat > $APACHE2_CONF <<EOF

ServerName $SERVER_NAME
DefaultRuntimeDir \${APACHE_RUN_DIR}
PidFile \${APACHE_PID_FILE}
Timeout 300
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
User \${APACHE_RUN_USER}
Group \${APACHE_RUN_GROUP}
HostnameLookups Off
ErrorLog \${APACHE_LOG_DIR}/error.log
LogLevel warn
IncludeOptional mods-enabled/*.load
IncludeOptional mods-enabled/*.conf
Include ports.conf
<Directory />
        Options FollowSymLinks
        AllowOverride None
        Require all denied
</Directory>

<Directory /usr/share>
        AllowOverride None
        Require all granted
</Directory>

<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
AccessFileName .htaccess
<FilesMatch "^\.ht">
        Require all denied
</FilesMatch>
LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %O" common
LogFormat "%{Referer}i -> %U" referer
LogFormat "%{User-agent}i" agent
IncludeOptional conf-enabled/*.conf
IncludeOptional sites-enabled/*.conf

EOF

echo -n "Type webmaster's email: "
read SERVER_ADMIN
echo -n "Type SSLCertificateFile dir: "
read SSLCER_FILE
echo -n "Type SSLCertificateKeyFile dir: "
read SSLCER_KEYFILE
cat > $DEFAULT_000 <<EOF 
<VirtualHost *:80>
        ServerAdmin $SERVER_ADMIN
        DocumentRoot /var/www/html
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
</VirtualHost>

<VirtualHost *:443>
    SSLEngine on
    SSLCertificateFile          $SSLCER_FILE
    SSLCertificateKeyFile       $SSLCER_KEYFILE
</VirtualHost>
EOF





