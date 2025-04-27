#!/bin/bash

containers=("mariadb-nfs-debian" "my-php-fpm-app1" "nginx-server-app1" "my-php-fpm-app2" "nginx-server-app2" "my-php-fpm-app3" "nginx-server-app3" "nginx-proxy")


# Loading variables on .env file
export $(grep -v '^#' .env | xargs)


# Setting network application
myDockerNetwork="myApp-network"
if ! docker network inspect "$myDockerNetwork"  >/dev/null 2>&1; then
  echo "Creating network.. $myDockerNetwork"
  docker network create "$myDockerNetwork"
else
  echo "Network ($myDockerNetwork) exist."
fi


# ====
# MAIN
# ====

clear

# Loop check if exist olders containers
for container in "${containers[@]}"; do
  if docker ps -a --format '{{.Names}}' | grep -Eq "^${container}\$"; then
    echo "Removing older container '${container}'..."
    docker rm -f "$container"
  fi
done

# Build images

# MariaDB-NFS
echo "Creating image MariaDB with nfs-server"
docker build -t mariadb-nfs-debian ./database
sleep 5

echo "Creating image my-php-fpm"
docker build -t my-php-fpm ./app
sleep 5


# Start database container

# Variables database MYSQL on env file
mysqlUp="docker run -d --name mariadb-nfs-debian --network myApp-network\
  -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  -e MYSQL_USER="$MYSQL_USER" \
  -e MYSQL_PASSWORD="$MYSQL_PASSWORD" \
  -v $(pwd)/database/banco.sql:/docker-entrypoint-initdb.d/banco.sql \
  -p 3306:3306 \
  -p 2049:2049 \
  -p 111:111 \
  --privileged \
  mariadb-nfs-debian"

eval "$mysqlUp"


# Start applications and nginx servers
for i in 1 2 3; do
  echo "Starting PHP-FPM app$i..."
  docker run -d --name my-php-fpm-app$i --network "$myDockerNetwork" \
    -v $(pwd)/app$i:/var/www/html \
    my-php-fpm

  echo "Starting NGINX server app$i..."
  docker run -d --name nginx-server-app$i --network "$myDockerNetwork" \
    -v $(pwd)/app$i:/var/www/html \
    -v $(pwd)/nginx/nginx-app$i.conf:/etc/nginx/conf.d/default.conf \
    nginx:latest
done


# Start NGINX Proxy
echo "Starting NGINX Proxy..."
docker run -d --name nginx-proxy --network "$myDockerNetwork" \
  -p 4500:4500 \
  -v $(pwd)/nginx/nginx-proxy.conf:/etc/nginx/conf.d/default.conf \
  nginx:latest


# Setting command to run docker PHP
#phpServer="docker run -d --name my-php-fpm --network myApp-network \
#  -v $(pwd)/app:/var/www/html \
#  my-php-fpm"

#nginxServer="docker run -d --name nginx-server --network myApp-network \
#            -p 8088:80 \
#            -v $(pwd)/app:/var/www/html \
#            -v $(pwd)/nginx/default.conf:/etc/nginx/conf.d/default.conf \
#            nginx:latest"












#echo "$phpServer"   # Show command on screen
#eval "$phpServer"

#echo "$nginxServer"
#eval "$nginxServer"