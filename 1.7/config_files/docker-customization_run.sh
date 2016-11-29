#!/bin/bash

echo "\n* Starting MySQL server ...";
service mysql start

echo "\n* Updating PrestaShop domains ...";
req='UPDATE ps_configuration SET value = "'$PS_DOMAIN'" WHERE name IN ("PS_SHOP_DOMAIN", "PS_SHOP_DOMAIN_SSL"); UPDATE ps_shop_url SET domain = "'$PS_DOMAIN'", domain_ssl = "'$PS_DOMAIN'";'
mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -D$DB_NAME -e "${req}"

if [ -n "$ID_MODULE" ]; then
	echo "\n* Requesting module $ID_MODULE ...";
	bash /tmp/get-module.sh&
fi

if [ -f ./app/config/parameters.php  ]; then
	rm ./app/config/parameters.php
fi

bash /tmp/docker_run.sh
