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
int nr_enfermeiros=0;
Enfermeiro *enfermeiros;
int nr_vacinas=0;


void trata_sinal(int sinal){
  if(sinal==17){ //SIGCHLD
    int pid_novo;
    pid_novo=wait(NULL);
    for(int i=0; i< NUM_VAGAS; i++)
      if(vagas[i].PID_filho == pid_novo){
        int old_index=vagas[i].index_enfermeiro;
        vagas[i].index_enfermeiro=-1;
        nr_vacinas--;
        sucesso("S5.5.3.1) Vaga %d que era do servidor dedicado %d libertada.",i,pid_novo);
        enfermeiros[old_index].disponibilidade=1;
        sucesso("S5.5.3.2) Enfermeiro %d atualizado para disponivel.",old_index);
        enfermeiros[old_index].num_vac_dadas++;
        sucesso("S5.5.3.3) Enfermeiro %d atualizado apra %d vacinas dadas.", old_index,enfermeiros[old_index].num_vac_dadas);
        if(!(file = fopen(FILE_ENFERMEIROS,"r+"))){
          erro("Não foi possivel atualizar o ficheiro %s.", FILE_ENFERMEIROS);
          return;
        }
        fseek(file,old_index*sizeof(e),SEEK_SET);
        fread(&e,sizeof(e),1,file);
        e.num_vac_dadas++;
        fseek(file,-1*sizeof(e),SEEK_CUR);
        fwrite(&e,sizeof(e),1,file);
        fclose(file);
        sucesso("S5.5.3.4)Ficheiro %s, enfermeiro index %d atualizado para %d vacinas dadas.",FILE_ENFERMEIROS,old_index,enfermeiros[old_index].num_vac_dadas);
        sucesso("S5.5.3.5) Retorna");
        return;
      }
  }

  if(sinal==15){ //SIGTERM
    for(int i=0; i<NUM_VAGAS; i++){
      if(vagas[i].PID_filho == 0){
        sucesso("S5.6.1) SIGTERM recebido, servidor dedicado termina cidadão %d.",vagas[i].cidadao.PID_cidadao);
        kill(vagas[i].cidadao.PID_cidadao, SIGTERM);
        exit(0);
      }
    }
  }
  
  if(sinal==2){ //SIGINT
    for(int i=0; i<NUM_VAGAS; i++)
      if(vagas[i].index_enfermeiro!=-1 && vagas[i].PID_filho!=0){
        kill(vagas[i].PID_filho,SIGTERM);
      }
    if(fork()==0)
      execl("/bin/rm","rm","-f",FILE_PID_SERVIDOR,NULL);
    wait(NULL);
    sucesso("Servidor terminado.");
    exit(0);
  }
    
  if(sinal==10){ //SIGUSR1  
    Cidadao cid;
    if(access("./pedidovacina.txt",F_OK) ==0){
      if(access("./pedidovacina.txt",R_OK)==0){
        file = fopen(FILE_PEDIDO_VACINA,"r");
        fscanf(file,"%d:%[^:]:%d:%[^:]:%[^:]:%d:%d",&cid.num_utente,cid.nome,&cid.idade,cid.localidade,cid.nr_telemovel,&cid.estado_vacinacao,&cid.PID_cidadao);
        fclose(file);
      }else{
        erro("S5.1) Não foi possivel ler o ficheiro %s",FILE_PID_SERVIDOR);
        return;
      }
    }else{
      erro("S5.1) Não foi abrir ler o ficheiro %s",FILE_PID_SERVIDOR);
      return;
    }
    
    
    sucesso("Chegou o cidadão com  o  pedido  nº %d, com  nº  utente  %d, para  ser  vacinado  no  Centro  de  Saúde %s.",cid.PID_cidadao,cid.num_utente,cid.localidade);
    sucesso("S5.1) Dados cidadão: %d; %s; %d; %s; %s; %d", cid.num_utente,cid.nome,cid.idade,cid.localidade,cid.nr_telemovel,cid.estado_vacinacao);
    for(int i=0; i<=nr_enfermeiros; i++){
      char cid_local[102]="CS";
      strcat(cid_local,cid.localidade);
      if((strcmp(enfermeiros[i].CS_enfermeiro,cid_local))==0){
        if(enfermeiros[i].disponibilidade==0){
          erro("S5.2.1) Enfermeiro %d indisponível para o pedido %d para o Centro de Saúde %s.",i,cid.PID_cidadao,cid.localidade);
          kill(cid.PID_cidadao,SIGTERM);
          return;
        }
        sucesso("S5.2.1) Enfermeiro %d disponível para o pedido %d.",i,cid.PID_cidadao);   
        if(nr_vacinas<NUM_VAGAS){
          sucesso("S5.2.2) Há vaga para a vacinação para o pedido %d.", cid.PID_cidadao);
          nr_vacinas++;
          for(int j=0; j<NUM_VAGAS; j++){
            if(vagas[j].index_enfermeiro==-1){ 
              vagas[j].index_enfermeiro=i;
              vagas[j].cidadao=cid;
              enfermeiros[i].disponibilidade=0;
              sucesso("S5.3) Vaga nº %d preenchida para o pedido %d.", j,cid.PID_cidadao);
              int pid_son=fork();
              if(pid_son==-1){
                erro("S5.4) Não foi possivel criar o servidor dedicado.");
                kill(cid.PID_cidadao,SIGTERM);
                return;
              } else if(pid_son==0){ 
                sucesso("S5.4) Servidor dedicado %d criado para %d.", getpid(),cid.PID_cidadao);
                signal(SIGTERM,trata_sinal);
                kill(vagas[j].cidadao.PID_cidadao, SIGUSR1);
                sucesso("S5.6.2) Servidor dedicado inicia consulta de vacinação.");
                sleep(TEMPO_CONSULTA);
                sucesso("S5.6.3) Vacinação terminada para o cidadao com pedido nº %d.", vagas[j].cidadao.PID_cidadao);
                kill(vagas[j].cidadao.PID_cidadao, SIGUSR2); 
                sucesso("S5.6.4) Servidor dedicado termina consulta de vacinação.");
                exit(0);
              } else {
              vagas[j].PID_filho=pid_son;
              sucesso("S5.5.1) Servidor dedicado %d na vaga %d.", pid_son,j);
              signal(SIGCHLD,trata_sinal);
              sucesso("S5.5.2) Servidor aguarda fim do servidor dedicado %d.", pid_son);
              return;
              }
            }
          }
        }
        erro("S5.2.2) Não há vaga para vacinação para o pedido %d",cid.PID_cidadao);
        kill(cid.PID_cidadao,SIGTERM);
        return;
      }
    }
    erro("S5.1.1) Não existem centros de saude com o nome %s.",cid.localidade);
    kill(cid.PID_cidadao,SIGTERM);
    return;
  }
}

int main () {
    
  if((file = fopen(FILE_PID_SERVIDOR,"w"))==NULL){
    erro("S1) Não consegui registar o servidor.");
    exit(0);
  }
  fprintf(file,"%d",getpid());
  fclose(file);
  sucesso("S1) Escrevi no ficheiro %s o PID: %d",FILE_PID_SERVIDOR,getpid());

  
  if(!(file = fopen(FILE_ENFERMEIROS,"r"))){
    erro("S2) Não consegui ler o ficheiro %s.", FILE_ENFERMEIROS);
    exit(0);
  } 
  
  nr_enfermeiros=0;    
  while(fread(&e,sizeof(e),1,file)>0)
    nr_enfermeiros++;
  fclose(file);  
  sucesso("S2) O ficheiro %s tem tamanho %d bytes, ou seja %d enfermeiros.",FILE_ENFERMEIROS,nr_enfermeiros*sizeof(e),nr_enfermeiros);
  enfermeiros=malloc(nr_enfermeiros*sizeof(Enfermeiro));
  file = fopen(FILE_ENFERMEIROS,"r");
  int count=0;
  while(fread(&e,sizeof(e),1,file)>0)
    enfermeiros[count++]=e;
  fclose(file);
  

  for(int i=0; i<NUM_VAGAS; i++)
    vagas[i].index_enfermeiro=-1;
  sucesso("S3) Iniciei a lista de %d vagas.",NUM_VAGAS);
    
  signal(SIGUSR1, trata_sinal);
  signal(SIGINT, trata_sinal);
  while(1){
    sucesso("S4) Servidor espera pedidos.");
    pause();
  }
    
}