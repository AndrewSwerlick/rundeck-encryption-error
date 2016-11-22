
#!/bin/bash

# OPTIONS:
#   DEFAULT_ADMIN_USER          Set the default admin user (defaults to "admin")
#   DEFAULT_ADMIN_PASSWORD      Set the default admin's password (defaults to "admin")
#   DEFAULT_USER                Set the default user (defaults to "docker")
#   DEFAULT_PASSWORD            Set the default user's password (defaults to "docker")
#   SERVER_MEMORY               Because Java is stupid
#   SERVER_PORT                 Sets Rundeck's listening port (defaults to "4440")
#   SERVER_URL                  Sets Rundeck's grails.serverURL
#   MYSQL_USER                  MySQL username
#   MYSQL_PASSWORD              MySQL password
#   MYSQL_ADDR                  MySQL address (defaults to "mysql")
#   MYSQL_DB                    MySQL database name (defaults to "rundeck")
#   USE_INTERNAL_IP             When SERVER_URL is undefined, use the container's eth0 address (otherwise try to guess external)

config_properties=$RDECK_BASE/server/config/rundeck-config.properties
sed -i "s,^grails\.serverURL.*\$,grails\.serverURL=${SERVER_URL}," $config_properties

# Source installation profile
. $RDECK_BASE/etc/profile

echo "STARTING RUNDECK"
exec java $RDECK_JVM -jar $RDECK_JAR --skipinstall &
rd_pid=$!

wait $rd_pid
echo "RUNDECK HAS DIED"
