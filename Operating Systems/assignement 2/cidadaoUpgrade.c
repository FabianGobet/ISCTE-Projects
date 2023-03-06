/******************************************************************************
 ** ISCTE-IUL: Trabalho prático de Sistemas Operativos
 **
 ** Aluno: Nº:       Nome: 
 ** Nome do Módulo: cidadao.c
 ** Descrição/Explicação do Módulo: 
 **
 **
 ******************************************************************************/
#include "common.h"

#include <unistd.h>
#include <stdlib.h>
#include <signal.h>


Cidadao cid;

void apaga(char *file){
  FILE *filo;
  if(filo=fopen(file,"r")){
    fclose(filo);
    if(fork()==0)
        execl("/bin/rm","rm",file,NULL);
    }
}

void trata_sinal(int sinal){
  if(sinal==15){ //SIGTERM
    sucesso("C9) Não é possível vacinar o cidadão no pedido nº %d.\n",cid.PID_cidadao);
    apaga(FILE_PEDIDO_VACINA);
    exit(0);
  }
  
  if(sinal==2){ //SIGINT
    sucesso("C5) O cidadao cancelou a vacinacao, o pedido n %d foi cancelado.", cid.PID_cidadao);
     apaga(FILE_PEDIDO_VACINA);
     exit(0);
  }
  
  if(sinal==14){ //SIGALRM
    sleep(5);
  }
  
  if(sinal==10){ //SIGUSR1
    sucesso("C7) Vacinação do cidadão com pedido nº %d em curso.",cid.PID_cidadao);
    apaga(FILE_PEDIDO_VACINA);
  }
  
   if(sinal==12){ //SIGUSR2
    sucesso("C8) Vacinação do cidadão com o pedido nº %d concluída.",cid.PID_cidadao);
    exit(0);
  }
}


int main(int argc, char *argv[]){
  
  FILE *file;
  char buffer[100];
  debug("%d", argc);
  
  if(argc!=6){
    debug("Introduza os seguintes dados.");
    debug("Numero de utente: ");
    scanf("%i", &cid.num_utente);
    debug("Nome: ");
    my_gets(cid.nome,100);
    debug("Idade: ");
    scanf("%i", &cid.idade);
    debug("Localidade: ");
    my_gets(buffer,100);  
    strcat(cid.localidade,buffer);
    debug("Telemovel: ");
    my_gets(cid.nr_telemovel,10);
  } 
  else{
    cid.num_utente=atoi(argv[1]);
    strcpy(cid.nome,argv[2]);
    cid.idade=atoi(argv[3]);
    strcat(cid.localidade,argv[4]);
    strcpy(cid.nr_telemovel,argv[5]);  
  }
  cid.estado_vacinacao = 0;  
  
  sucesso("C1) Dados cidadão: %d; %s; %d; %s; %s; %d", cid.num_utente,cid.nome,cid.idade,cid.localidade,cid.nr_telemovel,cid.estado_vacinacao);
  
  cid.PID_cidadao = getpid();
  sucesso("C2) PID Cidadão: %d",cid.PID_cidadao);

  
  while((file=fopen(FILE_PEDIDO_VACINA,"r"))!=NULL) {
    erro("C3) Não é possivel iniciar o processo de vacinação neste momento.");
    fclose(file);
    signal(SIGALRM,trata_sinal);
    kill(getpid(),SIGALRM);
    
  }
  sucesso("C3) Ficheiro %s pode ser criado.", FILE_PEDIDO_VACINA);
  
  if((file = fopen(FILE_PEDIDO_VACINA, "w"))==NULL){
    erro("C4) Não é possivel criar o ficheiro %s.", FILE_PEDIDO_VACINA);
    exit(1);
  }
  
  fprintf(file,"%d:%s:%d:%s:%s:%d:%d", cid.num_utente,cid.nome,cid.idade,cid.localidade,cid.nr_telemovel,cid.estado_vacinacao,cid.PID_cidadao);
  fclose(file);
  sucesso("C4) Ficheiro %s criado e preenchido", FILE_PEDIDO_VACINA);
  signal(SIGINT,trata_sinal);
    
  if(!(file=fopen(FILE_PID_SERVIDOR,"r"))){ 
    erro("C6) Não existe ficheiro %s!",FILE_PID_SERVIDOR);
    apaga(FILE_PEDIDO_VACINA);
    exit(1);
  }
    
  int serv_pid;
  fscanf(file,"%d",&serv_pid);
  fclose(file);
  kill(serv_pid,SIGUSR1);
  sucesso("C6) Sinal enviado ao servidor: %d", serv_pid);
  signal(SIGUSR1,trata_sinal);
  signal(SIGUSR2,trata_sinal);
  signal(SIGTERM,trata_sinal);

  while(1)
    pause();     
}
  
  
  