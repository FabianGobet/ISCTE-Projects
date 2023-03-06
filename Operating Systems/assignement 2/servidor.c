/******************************************************************************
 ** ISCTE-IUL: Trabalho prático de Sistemas Operativos
 **
 ** Aluno: Nº:       Nome: 
 ** Nome do Módulo: servidor.c
 ** Descrição/Explicação do Módulo: 
 **
 **
 ******************************************************************************/
#include "common.h"

#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>

Vaga vagas[NUM_VAGAS];

FILE *file;
char buffer[100];
Enfermeiro e;
int nr_enfermeiros;
Enfermeiro *enfermeiros;
int nr_vacinas=0;



      /*void insertEnfermeiro(Enfermeiro e){
        if(used==0){
          enfermeiros=malloc(sizeof(Enfermeiro));
          size++;
        }
        if(used==size){
          size++;
          enfermeiros=realloc(enfermeiros,size*sizeof(Enfermeiro));
        }
        enfermeiros[used++] = e;
        //enfermeiros[used++]=e;
        //enfermeiros[used-1].ced_profissional=e.ced_profissional;
        //debug("%d:%s:%s:%d:%d",e.ced_profissional,e.nome,e.CS_enfermeiro,e.num_vac_dadas,e.disponibilidade);
        //debug("%d:%s:%s:%d:%d",enfermeiros[used-1].ced_profissional,enfermeiros[used-1].nome,enfermeiros[used-1].CS_enfermeiro,enfermeiros[used-1].num_vac_dadas,enfermeiros[used-1].disponibilidade);
      }*/




void trata_sinal(int sinal){
  if(sinal==17){ //SIGCHLD
    pid_t pid_novo;
    pid_novo=wait(NULL);
    for(int i=0; i< NUM_VAGAS; i++)
      if(vagas[i].PID_filho == pid_novo){
        vagas[i].index_enfermeiro=-1;
        nr_vacinas--;
        enfermeiros[vagas[i].index_enfermeiro].disponibilidade=1;
        enfermeiros[vagas[i].index_enfermeiro].num_vac_dadas++;
        if(!(file = fopen(FILE_ENFERMEIROS,"r+"))){
          debug("Não foi possivel abrir o ficheiro %s", FILE_ENFERMEIROS); 
          kill(getpid(),SIGTERM); // acabar com todos os processos e encerrar o proprio
          exit(1);
        }
        fseek(file,vagas[i].index_enfermeiro*sizeof(e),SEEK_SET);
        fread(&e,sizeof(e),1,file);
        e.num_vac_dadas++;
        fseek(file,-1*sizeof(e),SEEK_CUR);
        fwrite(&e,sizeof(e),1,file);
        fclose(file);
      }
  }

  if(sinal==15){ //SIGTERM
    for(int i=0; i<NUM_VAGAS; i++)
      if(vagas[i].PID_filho == getpid()){
        debug("Processo de vacinação %d interrompido.",vagas[i].cidadao.PID_cidadao);
        kill(vagas[i].cidadao.PID_cidadao, SIGTERM);
        exit(0);
      }
  }
  
  if(sinal==2){ //SIGINT
    for(int i=0; i<NUM_VAGAS; i++)
      if(vagas[i].index_enfermeiro!=-1){
        kill(vagas[i].PID_filho,SIGTERM);
        kill(vagas[i].cidadao.PID_cidadao,SIGTERM);
      }
    if(fork()==0)
      execl("/bin/rm","rm","-f",FILE_PID_SERVIDOR,NULL);
    wait(NULL);
    debug("Saiu do processo servidor.");
    exit(0);
  }
    
  if(sinal==10){ //SIGUSR1  
    if(!(file = fopen(FILE_PEDIDO_VACINA,"r"))){
      debug("Erro ao abrir %s.\n", FILE_PEDIDO_VACINA);
      exit(1);
    }
    Cidadao cid;
    my_fgets(buffer,100,file);
    char *token;
    token=strtok(buffer,":");
    cid.num_utente=atoi(token);
    int count=0;
    while(token!=NULL){
      count++;
      if(count==2)
         strcpy(cid.nome,token);
      if(count==3)
         cid.idade=atoi(token);
      if(count==4)
        strcpy(cid.localidade,token);
      if(count==5)
        strcpy(cid.nr_telemovel,token);
      if(count==6)
        cid.estado_vacinacao=atoi(token);
      if(count==7)
        cid.PID_cidadao=atoi(token);
      token=strtok(NULL,":");
    }
    fclose(file);
    debug("Chegou o cidadão com  o  pedido  nº %d, com  nº  utente  %d, para  ser  vacinado  no  Centro  de  Saúde %s.",cid.PID_cidadao,cid.num_utente,cid.localidade);
    //debug("nr_enfermeiros: %d",nr_enfermeiros);
    for(int i=0; i<=nr_enfermeiros; i++){
      //debug("%s",enfermeiros[i].CS_enfermeiro,cid.localidade);
      if((strcmp(enfermeiros[i].CS_enfermeiro,cid.localidade))==0 && enfermeiros[i].disponibilidade==1){   //se enfermeiros[i](localidade)==localidade e disponivel
        debug("entrou 1");
        debug("%d %d",nr_vacinas,NUM_VAGAS);
        if(nr_vacinas<NUM_VAGAS){
          debug("entrou 2");
          for(int j=0; j<NUM_VAGAS; j++){
            debug("entrou 3");
            if(vagas[j].index_enfermeiro==-1){ //ha vagas
              debug("entrou 4");
              vagas[j].index_enfermeiro=i;
              nr_vacinas++;
              vagas[j].cidadao=cid;
              //debug("disponibilidade %d", enfermeiros[i].disponibilidade);
              enfermeiros[i].disponibilidade=0;
              //debug("havia vaga");
              int pid_son=fork();
              if(pid_son==0){ //o processo filho nao passa daqui
                signal(SIGTERM,trata_sinal);
                kill(vagas[j].cidadao.PID_cidadao, SIGUSR1);
                sleep(TEMPO_CONSULTA);
                debug("Vacinação terminada para o cidadao com pedido nº %d.", vagas[j].cidadao.PID_cidadao);
                kill(vagas[j].cidadao.PID_cidadao, SIGUSR2);
                //debug("FAZ ATE AQUI");
                exit(0);
              }
              else{
                vagas[j].PID_filho=pid_son;
                signal(SIGCHLD,trata_sinal);
                return;
              }
            }
          }
        }
        debug("Não há vaga para vacinação para o pedido %d",cid.PID_cidadao);
        kill(cid.PID_cidadao,SIGTERM);
        return;
        }
    }
    debug("Enfermeiro não disponível para o pedido %d para o Centro de Saúde %s.\n",cid.PID_cidadao,cid.localidade);
    kill(cid.PID_cidadao,SIGTERM);
    return;
  }
}

int main () {
    
  file = fopen(FILE_PID_SERVIDOR,"w");
  fprintf(file,"%d",getpid());
  fclose(file);
    
  if(!(file = fopen(FILE_ENFERMEIROS,"r"))){
    debug("Erro ao abrir %s.\n", FILE_ENFERMEIROS);
    exit(1);
  } 
  
  nr_enfermeiros=0;    
  while(fread(&e,sizeof(e),1,file)>0)
    nr_enfermeiros++;
    /*//debug("%d:%s",e.ced_profissional,e.nome);
    //insertEnfermeiro(e);
    if(used==0){
      enfermeiros=malloc(sizeof(Enfermeiro));
      size++;
    }
    if(used==size){
      size++;
      enfermeiros=realloc(enfermeiros,size*sizeof(Enfermeiro));
    }
    enfermeiros[used++] = e;
    //enfermeiros[used++]=e;
    //enfermeiros[used-1].ced_profissional=e.ced_profissional;
    //debug("%d:%s:%s:%d:%d",e.ced_profissional,e.nome,e.CS_enfermeiro,e.num_vac_dadas,e.disponibilidade);
    //debug("%d:%s:%s:%d:%d",enfermeiros[used-1].ced_profissional,enfermeiros[used-1].nome,enfermeiros[used-1].CS_enfermeiro,enfermeiros[used-1].num_vac_dadas,enfermeiros[used-1].disponibilidade);
  }*/  
  fclose(file);  
  
  enfermeiros=malloc(nr_enfermeiros*sizeof(Enfermeiro));
  
  file = fopen(FILE_ENFERMEIROS,"r");
  int nr_enfermeiros=0;
  while(fread(&e,sizeof(e),1,file)>0)
    enfermeiros[nr_enfermeiros++]=e;
  fclose(file);
  /*for(int j=0;j<size;j++)
   debug("%d:%s:%s:%d:%d",enfermeiros[j].ced_profissional,enfermeiros[j].nome,enfermeiros[j].CS_enfermeiro,enfermeiros[j].num_vac_dadas,enfermeiros[j].disponibilidade);*/
 //debug("nr_enfermeiros: %d",nr_enfermeiros);
  for(int i=0; i<NUM_VAGAS; i++)
    vagas[i].index_enfermeiro=-1;
    
  signal(SIGUSR1, trata_sinal);
  signal(SIGINT, trata_sinal);
  //debug("%d", getpid());
  while(1){
    debug("a espera");
    pause();
  }
    
}