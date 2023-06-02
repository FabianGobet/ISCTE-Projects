#!/bin/bash

# MUDAR PARA O NOME DO SERVIDOR
NOME_HOST="master"
NOME_DB="mqttData"
DB_PATH="/mongo/data/$NOME_DB/$NOME_HOST"
LOG_PATH="/mongo/log/$NOME_DB/$NOME_HOST"

chmod -R 700 /mongo/
#OLD=$(cat /etc/hostname)
#sed -i "s/$OLD/$NOME_HOST/g" /etc/hosts
#sed -i "s/$OLD/$NOME_HOST/g" /etc/hostname

#echo "$NOME_HOST" > /etc/hostname
mkdir -p "$DB_PATH"
mkdir -p "$LOG_PATH"
chmod -R 700 /mongo/
sed -i 's|DB_PATH|'"$DB_PATH"'|g' /mongo/mongod.conf
sed -i 's|LOG_PATH|'"$LOG_PATH/mongod.log"'|g' /mongo/mongod.conf
touch "$LOG_PATH/mongod.log"
chmod -R 777 /mongo/

mongod -f mongod.conf --fork
if [ $NOME_HOST = master ]; then
  echo "use admin"
  echo "rs.initiate()"
  echo 'db.createUser({ user: "root", pwd: "root", roles: ["root"] })'
  echo 'db.auth("root","root")'
  echo "use $DB_NOME"
  echo 'db.createCollection("mazemov14")'
  echo 'db.createCollection("mazelog14")'
  echo 'db.createCollection("mazemanage14")'
  echo 'db.createCollection("mazetemp14")'
  echo 'db.createUser({ user: "javaop", pwd: "javaop", roles: [{role: "readWrite", db: "mqttData"}] })'
  echo "use admin"
  echo "rs.add('slave1:30001')"
  echo "rs.add('slave2:30002')"
  echo "exit"
fi

#ps aux | grep 'mongod -f' | awk '{print $2}' | xargs kill -9

#sed -i '/^#security:/,/^\s*$/s/^#//' /mongo/mongod.conf
#sed -i 's/^#  authorization:/  authorization:/' /mongo/mongod.conf

# docker run -d -it -p 30000:27017 --hostname master --name mongobase fabiangobet/mongobase:0.97
# docker commit mongobase fabiangobet/mongobase:0.98