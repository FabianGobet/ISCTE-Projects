#!/bin/bash 

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos
##
## Aluno: Nº: 97885       Nome: Fabian Flores Gobet
## Nome do Módulo: lista_cidadaos.sh
## Descrição/Explicação do Módulo: 
##  -A descrição deste modulo esta feita por meio de comentarios no decorrer do codigo
##
###############################################################################
 
 if [ ! -f ./listagem.txt ] 
 # Esta condição verifica se no diretorio atual NÃO existe algum ficheiro chamado listagem.txt
 then
   echo "Não existe ficheiro listagem.txt neste diretorio."
   
 else
   rm -f ./cidadaos.txt
   # Se na pasta onde se situa este script já existe um ficheiro chamado listagem.txt, ele faz force remove ao mesmo
   # Isto vai permitir-nos criar um novo sem problemas
   
   cat -n listagem.txt | sed 's/^ *//g' | sed 's/ |//g' | sed 's/:/ /g' | sed 's/-/ /g' | awk '{print $1+10000":"$3,$4":"2021-$10":"$12":"$14":0"}' > cidadaos.txt
   # O comando cat -n deixa varios espaços no inicio de cada linha, é possivel elimina-los com sed 's/^ *//g' .
   # No entanto encontrei alguma dificuldade a definir varios delimitadores para o comando awk -F'[DELIM]' ,
   # pelo que decidi substituir todos os caracteres "|" e ":" por espaços de forma agilizar o funcionamento
   # com delimitador default do comando awk.
   
   cat ./cidadaos.txt
   # mostra cidadaos.txt ao user

 fi
 
