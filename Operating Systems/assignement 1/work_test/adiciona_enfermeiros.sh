#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos
##
## Aluno: Nº: 97885      Nome: Fabian Flores Gobet
## Nome do Módulo: adiciona_enfermeiros.sh
## Descrição/Explicação do Módulo: 
##   - Este modulo é composto por uma sequencia de estruturas de controlo "if" que vão testando se os argumentos passados estão na formatação pretendida,  
##     e posteriormente se já existe um enfermeiro na localidade, e caso não haja, se o enfermeiro esta inscrito noutro centro de saude.
##   - Foram adicionados alguns comentarios ao longo do codigo para facilitar a perceção do que está a acontecer. 
##
###############################################################################

touch ./enfermeiros.txt # caso o ficheiro nao exista, é criado. caso contrario é apenas atualizado.

b="----------------------------------------------" # apenas para aparencia do output
a="\nErro: Síntaxe:$0 <nome> <nºde cédula profissional> <localidade do centro de saude associado> <disponibilidade>\n"

#if [[ $1 =~ "\""[A-Za-z\ ]+$"\"" && $($1 | wc -w) == 2 ]] ; then    # verifica se o primeiro arguento passado é composto apenas or letras minusculas, maiusculas e espaços.
if [[ $1 =~ ^[A-Za-z\ ]+$ && $(echo $1 | wc -w) == 2 ]] ; then    # verifica se o primeiro arguento passado é composto apenas por letras minusculas, maiusculas e espaços, e se é composto por dois nomes
  if [[ $2 =~ ^[0-9]+$ ]] ; then       # verifica se o segundo argumento passado é composto apenas por numeros.
    if [[ $3 =~ ^"CS"[A-Z][a-zA-Z]+$ ]] ; then   # verifica se o terceiro argumento passado vem na formatação correta tipo "CSLocalidade".
      if [[ $4 =~ [0-1] ]] ; then              # verifica se o quarto argumento passado é 0 ou 1.
        if [[ $(grep ":"$3":" ./enfermeiros.txt | wc -l) != 0 ]] ; then 
        #  O "if" acima verifica se em enfermeiros.txt, do diretorio atual, existe alguma linha com a palavra ":CSLocalidade:". Escolhi incluir os dois pontos no inicio e no fim porque podem haver localidades diferentes com partes da           #  nomenclutura coencidentes. Por exemplo Vilareal e Vilarealsantoantonio.
          echo -e "\nErro: O centro de saúde introduzido já tem um enfermeiro registado.\n"$b
        else
          if [[ $(grep "^$2:" ./enfermeiros.txt | wc -l) != 0 ]] ; then 
          #  O "if" acima verifica se em enfermeiros.txt, do diretorio atual, existe alguma linha comecada com numero de cedula passado como argumento. É preciso considerar os dois pontos para que seja exatamente o mesmo numero.
            echo -e "\nErro: Este enfermeiro já se encontra registado noutro centro de saúde.\n"$b
          else
            echo $2":"$1":"$3":0:"$4 >> enfermeiros.txt  #  adiciona uma linha a enfermeiros.txt com a formataçao pedida.
            echo -e "\e[92m\nEnfermeiro adicionado com sucesso!\e[39m\n\nLista de enfermeiros: \n"
            cat ./enfermeiros.txt
            echo $b
          fi
        fi
      else
       # cada echo abaixo representa um erro para cada um dos argumentos passados, tendo no inicio uma mensagem comum a todos, guardada na variavel "a".
        echo -e $a"Erro: O argumento <disponibilidade> não esta escrito na formatação esperada.\nDeve escrever 0 ou 1, consoante a disponibilidade.\n"$b
      fi
    else
      echo -e $a"Erro: O argumento <localidade do centro de saude associado> não esta escrito na formatação esperada.\nDeve escrever algo como "Lisboa", tendo atenção à inicial maiuscula.\n"$b
    fi
  else
    echo -e $a"Erro: O argumento <nº de cédula profissional> não esta escrito na formatação esperada.\nDeverá introduzir um inteiro positivo, por exemplo 6969.\n"$b
  fi
else
  echo -e $a"Erro:O argumento <nome> não esta escrito na formatação esperada.\nDeverá introduzir o nome na forma \"Nome Apelido\" usando apenas letras, espaços e exatamente dois nomes.\n"$b
fi