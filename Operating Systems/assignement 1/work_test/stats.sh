#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos
##
## Aluno: Nº: 97885      Nome: Fabian Flores Gobet
## Nome do Módulo: stats.sh
## Descrição/Explicação do Módulo: 
##  - Este modulo extrai informacao de cidadaos.txt e enfermeiros.txt.
##  - Essa informação pode ser a lista de cidadaos numa localidade, a lista de cidadaos com mais de 60 anos registados e a lista de enfermeiros disponiveis.
##  - Foram adicionados alguns comentarios ao longo do codigo para facilitar a perceção do que está a acontecer. 
##
###############################################################################

b="----------------------------------------------" # apenas para aparencia do output

case $1 in # caso o primeiro argumento seja algum dos 4 casos seguintes, age de acordo
  cidadaos) 
    if [[ $2 =~ ^[A-Z][A-Za-z]+$ ]] ; then # testa se o segundo argumento vem com a formatacao convencional de uma localidade, sem espaços
      if [[ -e ./cidadaos.txt ]] ; then # caso o ficheiro cidadaos exista no diretorio
        a=$(grep ":$2:" cidadaos.txt | wc -l) # pesquisa em quantas linhas do ficheiro existe a ocorrencia :<localidade>:
        echo -e "\n\e[92mO numero de cidadaos registados em $2 é $a.\e[39m\n"$b # retorna a mensagem para o user
      else
        echo -e "\nErro: O ficheiro cidadaos.txt não esta neste diretorio.\n"$b # mensagem caso o ficheiro cidadaos.txt nao exista
      fi
    else
      echo -e "\nErro: Síntaxe:$0 cidadaos <localidade>\nDeve escrever <localidade> com inicial maiuscula, sem espaços e apenas letras.\nPor exemplo: $0 cidadaos Lisboa\n"$b 
      # mensagem caso a localidade nao seja escrita como pretendido
    fi 
  ;;
            
  registados) 
    if [[ ! -e ./cidadaos.txt ]] ; then # verifica a existencia do ficheiro cidadaos.txt
      echo -e "\nErro: O ficheiro cidadaos.txt não esta neste diretorio.\n"$b # caso nao exista retorna a mensagem
    else
      echo -e "\e[92m\nLista de cidadaos com mais de 60 anos inscritos:\e[39m\n" 
      awk -F":" '{if($3>60) {print $3,$1,$2}}' cidadaos.txt | sort -n -r -k 1 | awk '{print $2,$3,$4}' # caso contrario, verifica em cidadaos.txt as pessoas com mais de 60 anos e organiza uma lista com idade, nome e localidade
      echo $b                                                                                          # depois organiza essa lista de forma decrescente consoante a idade, que é a primeira palavra, e por fim extrai apenas 
    fi
  ;;                                                                                              # o numero de utente e o primeiro e ultimo nome
  enfermeiros) 
    if [[ ! -e ./enfermeiros.txt ]] ; then # verifica se existe enfermeiros.txt no diretorio
      echo -e "\nErro: O ficheiro enfermeiros.txt não esta neste diretorio.\n"$b # mensagem caso nao exista
    else
      echo -e "\n\e[92mLista de enfermeiros disponiveis inscritos:\e[39m\n"
      awk -F":" '{if($5==1) {print $2}}' ./enfermeiros.txt # caso existe, retorna uma mensagem apresentando a lista daqueles enfermeiros que estao disponiveis em enfermeiros.txt
      echo $b
    fi 
  ;;
  *) 
    echo -e "\nErro: Síntaxe:$0 <cidadaos/registados/enfermeiros> <localidade>\nDeve usar os argumentos descritos.\nO segundo argumento só terá validação caso o primeiro seja <cidadaos>\nPor exemplo: $0 cidadaos Lisboa\n"$b
    # o echo acima mostra uma mensagem quando nenhum dos pressupostos 3 argumentos iniciais seja utilizado
  ;;
esac