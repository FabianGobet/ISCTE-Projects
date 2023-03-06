/******************************************************************************
 ** ISCTE-IUL: Trabalho prático de Sistemas Operativos
 **
 ** Aluno: Nº: 97885      Nome: Fabian Flores Gobet
 ** Nome do Módulo: cidadao.c
 ** Descrição/Explicação do Módulo: 
 ** -Este módulo vem com a opçao adicional de executar o cidadao com os respetivos dados diretamente a partir do terminal,
 **  isto é ./cidadao <n utente> <nome> <idade> <localidade> <nr telemovel>. Este pedaço de codigo facilita imenso testes ao funcionamento do modulo
 ** -A descrição do modulo é feita através de comentarios ao longo do código.
 **
 ******************************************************************************/
#include "common.h"

#include <unistd.h> 
#include <stdlib.h>  
#include <signal.h> // biblioteca necessária para fazer o uso de sinais


Cidadao cid; //esta variavel é definida globalmente para ser acessivel pelas funções fora do main

void apaga(char *file){       //Esta função é responsavel por apagar o ficheiro *file. O metodo consiste ne verificação da existencia do mesmo através de uma abertura para leitura, e depois de um fecho seguido de um
  FILE *filo;                 //fork() onde o filho se responsabiliza da eliminação do fichero través do comando execl
  if(filo=fopen(file,"r")){
    fclose(filo);
    if(fork()==0)
        execl("/bin/rm","rm",file,NULL);
    }
}

void trata_sinal(int sinal){ //esta função trata todos os sinais, consoante o sinal recebido
  
  if(sinal==15){ //SIGTERM
    sucesso("C9) Não é possível vacinar o cidadão no pedido nº %d.\n",cid.PID_cidadao); //no caso de receber o sinal SIGTERM, mostra a mensagem e apaga o ficheiro pedidovacina.txt e termina o processo
    apaga(FILE_PEDIDO_VACINA); 
    exit(0);
  }
  
  if(sinal==2){ //SIGINT
    sucesso("C5) O cidadao cancelou a vacinacao, o pedido n %d foi cancelado.", cid.PID_cidadao); //no caso de receber o sinal SIGINT, mostra a mensagem e apaga o ficheiro pedidovacina.txt e termina o processo
     apaga(FILE_PEDIDO_VACINA);
     exit(0);
  }
  
  if(sinal==14){ //SIGALRM 
    sleep(5); //no caso de receber o sinal SIGALRM, faz um sleep de 5 segundos e depois volta aonde estava antes 
  }
  
  if(sinal==10){ //SIGUSR1
    sucesso("C7) Vacinação do cidadão com pedido nº %d em curso.",cid.PID_cidadao); //no caso de receber o sinal SIGUSR1, significa que o servidor esta a vacinar o cidadao, mostra a mensagem, e apaga o ficheiro pedidovacina.txt
    apaga(FILE_PEDIDO_VACINA);
  }
  
   if(sinal==12){ //SIGUSR2
    sucesso("C8) Vacinação do cidadão com o pedido nº %d concluída.",cid.PID_cidadao); 
    //no caso de receber o sinal SIGUSR2, significa que o servidor terminoou de vacinar o cidadao, mostra a mensagem, e apaga o ficheiro pedidovacina.txt
    exit(0);
  }
}


int main(int argc, char *argv[]){ //este main tem a opção de inserir os argumentos direatamente no terminal mediante a execução do programa, ou entao ele vai pedindo os dados
  
  FILE *file;
  char buffer[100];
  
  if(argc!=6){ //caso o numero de argumentos introduzidos mediante a execução seja diferente de 6 (tem de ser 6 pk o o proprio nome do executavel é o primeiro argumento), ele pede os dados "manualmente"
    sucesso("Introduza os seguintes dados.");
    sucesso("Numero de utente: ");
    scanf("%i", &cid.num_utente);
    sucesso("Nome: ");
    my_gets(cid.nome,100);
    sucesso("Idade: ");
    scanf("%i", &cid.idade);
    sucesso("Localidade: ");
    my_gets(buffer,100);  
    strcat(cid.localidade,buffer);
    sucesso("Telemovel: ");
    my_gets(cid.nr_telemovel,10);
  } 
  else{ //caso o numero de argumentos seja 6, ele associa logo os dados diretamente à variavel do tipo cidadao que criamos como variavel global
    cid.num_utente=atoi(argv[1]); //sendo que argv[0] é o nome do executavel
    strcpy(cid.nome,argv[2]);
    cid.idade=atoi(argv[3]);
    strcpy(cid.localidade,argv[4]);
    strcpy(cid.nr_telemovel,argv[5]);  
  }
  cid.estado_vacinacao = 0;  // independentemente do metodo de introdução de dados, o estado_vacinação inicia sempre a zero 
  
  sucesso("C1) Dados cidadão: %d; %s; %d; %s; %s; %d", cid.num_utente,cid.nome,cid.idade,cid.localidade,cid.nr_telemovel,cid.estado_vacinacao);
  
  cid.PID_cidadao = getpid(); 
  sucesso("C2) PID Cidadão: %d",cid.PID_cidadao);

  signal(SIGALRM,trata_sinal); //arma o sinal SIGLARM acaso o ficheiro pedidovacinas.txt ja existe
  
  while((file=fopen(FILE_PEDIDO_VACINA,"r"))!=NULL) { // caso consiga abrir o ficheiro para ler, quer dizer que este ja existe, e entao mostra uma mensagem a dizer que não é preciso iniciar de momentoo processo 
    erro("C3) Não é possivel iniciar o processo de vacinação neste momento.");
    fclose(file);
    kill(getpid(),SIGALRM); //apos o fecheo do ficheiro manda um SIGALRM a si proprio para esperar 5 segundos, e repete o while
    
  }
  sucesso("C3) Ficheiro %s pode ser criado.", FILE_PEDIDO_VACINA); //quando sair do while, quer dizer que o ficheiro pedidovacians.txt nao existe, e manda uma mensagem de sucesso a dizer que ja ha condições para criar o ficheiro
  
  if((file = fopen(FILE_PEDIDO_VACINA, "w"))==NULL){ 
    erro("C4) Não é possivel criar o ficheiro %s.", FILE_PEDIDO_VACINA); // se nao conseguir criar ou escrever o ficheiro pedidovacinas.txt, manda uma mensgaem de erro e termina o processo
    exit(1);
  }
  
  fprintf(file,"%d:%s:%d:%s:%s:%d:%d", cid.num_utente,cid.nome,cid.idade,cid.localidade,cid.nr_telemovel,cid.estado_vacinacao,cid.PID_cidadao); //por outro lado, sec onseguir escreve nele os dados do cidadao
  fclose(file);
  sucesso("C4) Ficheiro %s criado e preenchido", FILE_PEDIDO_VACINA); // e manda uma mensagem de cucesso a dizer que conseguiu escrever la esses dados
  
  signal(SIGINT,trata_sinal); //arma o sinal SIGINT antes de mandar informação ao servidor, caso o utilizador termine o processo cidadao manualmente 
    
  if(!(file=fopen(FILE_PID_SERVIDOR,"r"))){ // caso nao consiga abrir para leitura o ficheiro que contem o numero do pid do servidor, mostra mensagem de erro e termina o processo, apagando pedidovaina.txt
    erro("C6) Não existe ficheiro %s!",FILE_PID_SERVIDOR); 
    apaga(FILE_PEDIDO_VACINA);
    exit(1);
  }
    
  int serv_pid; //caso contrario, le o pid do servidor do ficheiro e guarda numa variavel chamada serv_pid
  fscanf(file,"%d",&serv_pid);
  fclose(file);
  signal(SIGUSR1,trata_sinal); //arma os sinais antes de mandar o sinal ao servidor
  signal(SIGUSR2,trata_sinal);
  signal(SIGTERM,trata_sinal);

  kill(serv_pid,SIGUSR1); //de seguinda manda um sinal ao servidor para que este possa ler o ficheiro pedidovacinas.txt para fazer, ou nao, a admissao do cidadao, e sinalizar de volta
  sucesso("C6) Sinal enviado ao servidor: %d", serv_pid);
  
  while(1) // espera passiva enquanto recebe sinais de volta do servidor
    pause();     
}
  
  
  