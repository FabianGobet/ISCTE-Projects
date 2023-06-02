# COMANDO EXEMPLO PARA IMAGEM MACHINE 0
# docker build --build-arg INDX=0 -t machine0 .



# ---------------- UBUNTU, MONGODB E VIM -------------------------
FROM ubuntu
ARG INDX
RUN apt-get update && apt-get install gnupg -y && apt-get -y install curl
RUN curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN apt-get update
RUN apt-get install -y mongodb-org
RUN apt-get install -y vim



# ---------------- ESTRUTURA DE DIRETORIOS E LOGS -------------------------
RUN echo "$INDX"
RUN mkdir -p /mongo/cfg$INDX/data /mongo/cfg$INDX/log /mongo/a$INDX/data /mongo/b$INDX/data /mongo/c$INDX/data /mongo/a$INDX/log /mongo/b$INDX/log /mongo/c$INDX/log
RUN touch /mongo/cfg$INDX/log/logs.log /mongo/a$INDX/log/logs.log /mongo/b$INDX/log/logs.log /mongo/c$INDX/log/logs.log



# ---------------  APENAS GERAR KEYFILE NUMA MAQUINA E COPIAR PARA /mongo NAS OUTRAS-----------------------------
RUN openssl rand -base64 756 > keyfile



# ------------------- SCRIPTS ---------------------------
RUN echo "mongod -f /mongo/cfg$INDX.conf\nmongod -f /mongo/a$INDX.conf\nmongod -f /mongo/b$INDX.conf\nmongod -f /mongo/c$INDX.conf" > /run$INDX.sh
RUN echo "rm -r /mongo/cfg$INDX/data/* /mongo/a$INDX/data/* /mongo/b$INDX/data/* /mongo/c$INDX/data/*\nfind /mongo -type f -name \"logs.log\" -exec sh -c 'echo -n > \"{}\"' \\;" > /reset$INDX.sh
RUN chmod -R 700 /mongo run$INDX.sh



# -------------- APENAS PARA MONGOS (ROUTER) SETUP ------------------------
#RUN mkdir mongo && cd mongo
#RUN mkdir -p s0/data s0/log
#RUN touch s0/log/logs.log
# COPIAR KEYFILE PARA /mongo
#RUN chmod 600 keyfile



