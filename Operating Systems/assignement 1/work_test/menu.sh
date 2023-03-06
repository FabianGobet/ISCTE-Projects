#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos
##
## Aluno: Nº:       Nome: 
## Nome do Módulo: menu.sh
## Descrição/Explicação do Módulo: 
##  - Este modulo faz uma representação grafica das opçoes dispostas ao utilizador, invocando os ficheiros previamente desenvolvidos consoante as opçoes
##  - É feita a verificação da esistencia do ficheiro que depende da opção que o utilizador escolheu ao longo do codigo
##  - O menu fica disponivel de forma iterada ao utilizador até que este decida sair do mesmo, assim como os sub-menus associdados
##  - Foram adicionados alguns comentarios ao longo do codigo para facilitar a perceção do que está a acontecer.
##
###############################################################################

g="----------------------------------------------"
i=1

while [[ $i != 0 ]]; do    #enquanto o i for diferente de 0 vamos interar sobre a linha de codigo seguinte, isto é, o menu, de forma apresneta-l ate que a opcao 0 seja selecionada, que mete i=0
  echo -e $g"\n             MENU"
  echo -e " Escolha o numero de uma das seguintes opções\n"   
  echo -e "\e[34m1\e[39m. Listar cidadãos"
  echo -e "\e[34m2\e[39m. Adicionar enfermeiro"       #apresentação standart do menu, com alguma formatação de cores para tornar mais obvia a necessidade de slecionar o numero da opçao
  echo -e "\e[34m3\e[39m. Stats"
  echo -e "\e[34m4\e[39m. Agendar vacinação"
  echo -e   "\e[34m0\e[39m. Sair"
  echo -n "Opcao: "
  read i
    case $i in # aqui vamos verificar os varios casos possiveis para a opcao escolhida
      1) 
        if [[ -e ./lista_cidadaos.sh ]]; then # no caso de escolher listar cidadaos, como esta opcao depende do ficheiro lista_cidadaos.sh é preciso verificar se este esta na pasta
          ./lista_cidadaos.sh # execute lista_cidadaos.sh na pasta corrente
        else
          echo -e "\nErro: O ficheiro lista_cidadaos.sh não se encontra na pasta!\n" #erro caso nao esteja na pasta
        fi
      ;;
      2)
        if [[ -e ./adiciona_enfermeiros.sh ]]; then  # no caso de escolher Adicionar enfermeiros, como esta opcao depende do ficheiro adiciona_enfermeiros.sh é preciso verificar se este esta na pasta
          a=0
          while [[ $a != sair ]]; do # este while serve para irmos adicionando enfermeiros indefinidamente ate que seja escrito sair no nome de enfermeiro
            echo -e "\n\e[5mATENÇÃO: \e[25mCaso queira voltar ao menu principal escreva \e[4msair\e[24m \e[39mno nome do enfermeiro."  # formatacao de texto e indicações para utilizador
            echo -e -n "\nIntroduza \e[4mapenas o primeiro e o ultimo nome\e[24m do enfermeiro. Exemplo: Mario Gonçalves\nNome: "
            read a e # aqui vamos ler o nome e apelido do enfermeiro
            if [[ $a != sair ]]; then # caso o nome nao tenha sido sair, escrito no nome de enfermeiro como descrito acima, entao executamos o seguinte codigo
              a=$(echo $a | sed 's/"//g') # é preciso formatar o input para certificar que nao ha aspas no nome
              e=$(echo $e | sed 's/"//g') # igualmente faremos o mesmo para o apelido
              echo -e -n "\nIntroduza \e[4mapenas o numero de cédula profissional\e[24m do enfermeiro. Exemplo: 12345\nNumero: "
              read b # le o numero de cedula
              echo -e -n "\nIntroduza \e[4mos nomes da localidade todos juntos, com inicial maiuscula\e[24m, do centro de saude do enfermeiro. Exemplo: VilaRealStoAntonio\nLocalidade: "
              read c # le a localidade
              c=$(echo $c | sed 's/"//g') # é perciso formatar igualmente ao nome e apelido
              echo -e -n "\nIntroduza a disponibilidade do enfermeiro, 0 ou 1, se disponivel ou nao, respetivamente. Exemplo: 0\nDisponibilidade: "
              read d # le a disponibilidade
              ./adiciona_enfermeiros.sh "$a $e" $b "CS$c" $d # é preciso juntar a variavel $a e $e numa so, e juntar "CS" ao inicio de $e e mandar este input para adiciona_enfermeiros.sh
            fi
          done
        else 
           echo -e "\nErro: O ficheiro adiciona_enfermeiros.sh não se encontra na pasta!\n" # mensagem de erro caso o ficheiro adiciona_enfermeiros.sh nao esteja na pasta
        fi
      ;;
      3)
        if [[ -e ./stats.sh ]]; then   # no caso de escolher Stats, como esta opcao depende do ficheiro stats.sh é preciso verificar se este esta na pasta
          a=-1
          while [[ $a != 0 ]]; do  # enquanto o utilizador nao decidir voltar ao menu principal, fica dentro deste sub menu
            echo -e "\n\e[96m1\e[39m. Numero de cidadaos inscritos numa localidade"
            echo -e "\e[96m2\e[39m. Lista com numero de utente e nome dos cidadaos inscritos com mais de 60 anos" # sub menu com formatação pomposa
            echo -e "\e[96m3\e[39m. Lista com nome dos enfermeiros disponiveis"
            echo -e "\e[96m0\e[39m. Voltar ao menu principal"
            echo -n "Opcao: "
            read a 
            if [[ $a != 0 ]]; then # caso o utilizador nao deseje sair, vamos verificar os varios casos que ele pode ter escolhido
              case $a in
                1) 
                  echo -e -n "\nIntroduza \e[4mapenas o nome da localidade de pesquisa, com inicial maiuscula\e[24m. Exemplo: Lisboa\nLocalidade: "
                  read c
                  ./stats.sh cidadaos $c # este primeiro caso execute stats.sh com o argumento cidadaos
                ;;
                  2)
                  ./stats.sh registados  # este segundo caso execute stats.sh com o argumento registados
                ;;
                  3)
                  ./stats.sh enfermeiros # este terceir caso execute stats.sh com o argumento enfermeiros
                ;;
                *)
                  echo "\nDeverá introduzir o numero de alguma das opções.\n" #caso nenhuma das opções descriminadas tenha sido escolhida
                ;;
              esac
            fi
          done
        else
          echo -e "\nErro: O ficheiro stats.sh não se encontra na pasta!\n" # mensagem de erro caso o ficheiro stats.sh nao esteja na pasta
        fi
      ;;
      4)
        if [[ -e ./agendamento.sh ]]; then  # no caso de escolher Agendamento, como esta opcao depende do ficheiro agendamento.sh é preciso verificar se este esta na pasta
          ./agendamento.sh # caso esteja executa o mesmo
        else
          echo -e "\nErro: O ficheiro agendamento.sh não se encontra na pasta!\n" # mensagem de erro caso o ficheiro agendamento.sh nao esteja na pasta
        fi
      ;;
      0) # Caso a pessoa escolha 0, nao ha nenhum bloco de instruções para tal e portanto ele faz um novo ciclo while e sai do  menu. 
      ;;
      *)
        echo -e "\nErro: Deverá introduzir o numero de uma das opções 0 até 4.\n" # mensagem de erro caso nao seja usada nenhum das opçoes acima descriminadas
      ;;
    esac
done
echo -e "\n\e[92mSaiu do menu com sucesso. Até à proxima!\e[39m\n"$g # mensagem a informar o utilizador que saiu do menu