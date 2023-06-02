FROM ubuntu:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install vim -y && \
    apt-get install gnupg -y && \
    apt-get install wget -y && \
    apt-get install curl -y && \
    apt-get install iputils-ping -y && \
    curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    apt-get update && \
    apt-get install -y original-awk && \
    apt-get install -y man && \
    apt-get install -y mongodb-org

RUN mkdir mongo && \
    cd mongo && \
    mkdir data && \
    mkdir log && \
    cd log && \
    touch mongod.log && \
    cd .. && \
    cd data && \
    mkdir mqttData && \
    cd mqttData 
    #mkdir $SERVER_NAME && \
    #cp /etc/mongod.conf /mongo/mongod.conf

#RUN cd /etc && touch hosts && \
# 	 echo "$IP_ADDR master" >> /etc/hosts && \
#    echo "$IP_ADDR slave1" >> /etc/hosts && \
#    echo "$IP_ADDR slave2" >> /etc/hosts

COPY mongod.conf /mongo/
RUN cd /mongo && \
    sed -i "s/SERVER_NAME/master/g" mongod.conf

COPY keyfile /mongo
RUN chmod -R 700 /mongo

EXPOSE 27017
