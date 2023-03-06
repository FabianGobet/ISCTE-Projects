#include "common.h"

#include <unistd.h>
#include <stdlib.h>
#include <signal.h>

int main () {
  
  FILE *file;
  FILE *filo;  
  if(!(file = fopen("enfermeiros.dat","r"))){
    debug("Erro ao abrir enfermeiros.dat.\n");
    exit(1);
  } 
  filo = fopen("enfermeiros.txt","w");
  Enfermeiro e;    
  while(fread(&e,sizeof(e),1,file)>0){
    fprintf(filo,"%d:%s:%s:%d:%d\n", e.ced_profissional,e.nome,e.CS_enfermeiro,e.num_vacinas_dadas,e.disponibilidade);
  }
  fclose(file);
  fclose(filo);
  
  if(!(file = fopen("cidadaos.dat","r"))){
    debug("Erro ao abrir enfermeiros.dat.\n");
    exit(1);
  } 
  filo = fopen("cidadaos.txt","w");
  Cidadao cid;    
  while(fread(&cid,sizeof(cid),1,file)>0){
    fprintf(filo,"%d:%s:%d:%s:%s:%d:%d\n", cid.num_utente,cid.nome,cid.idade,cid.localidade,cid.nr_telemovel,cid.estado_vacinacao,cid.PID_cidadao);
  }
  fclose(file);
  fclose(filo);
}