#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos
##
## Aluno: Nº: 97885      Nome: Fabian Flores Gobet
## Nome do Módulo: agendamento.sh
## Descrição/Explicação do Módulo: 
##  - Este modulo faz uma concatenaçao do enfermeiro disponivel e numero de cedula, com os pacientes do respetivo centro de saude.
##  - A estrutura do codigo tem como base um ciclo for que vai interar sobre as cedulas dos enfermeiros disponiveis, vendo depois se na sua localidade
##    existem pacientes para ser vacinados.
##  - Foram adicionados alguns comentarios ao longo do codigo para facilitar a perceção do que está a acontecer.
##
###############################################################################

g="----------------------------------------------" # apenas para aparencia do output

if [[ -e ./agenda.txt ]] ; then
  rm -f agenda.txt
  touch agenda.txt
fi

for i in $(awk -F":" '{if($5==1) {print $1}}' ./enfermeiros.txt); do # iteracao sobre numero da cedula dos enfermeiros disponiveis
  a=$(grep "^$i:" enfermeiros.txt | awk -F":" '{print $2":"$1":"}') # gera uma variavel com nome:cedula: do enfermeiro
  b=$(grep "^$i:" enfermeiros.txt | awk -F":" '{print $3}' | sed 's/^CS//g') # gera uma variavel com a localidade sem "CS" no inicio
  c=$(date +%F) #variavel com a data na formataçao pedida
  grep ":$b:" cidadaos.txt | awk -F":" '{print ":"$2":"$1":"}' >> agenda.txt # procura os cidadaos com a localidade igual à variavel, e formata cada linha pondo :nome_cidadao:nº utente:
  sed -i "s/^:/$a/g" agenda.txt # no inicio da linha mete o nome e cedula do enfermeiro 
  sed -i "s/:$/:CS$b:$c/g" agenda.txt   # no fim da linha mete o centro de saude e a data
done
echo -e "\e[92m\nAgenda gerada com sucesso!\e[39m\n"