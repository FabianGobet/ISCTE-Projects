#include "common.h"

#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>



FILE *file;
FILE *filo;
Enfermeiro e;

int main () {
    
    
 
  /*int index=0;
  fseek(file,index*sizeof(e),SEEK_SET);
  fread(&e,sizeof(e),1,file);
  e.num_vac_dadas++;
  fseek(file,-1*sizeof(e),SEEK_CUR);
  fwrite(&e,sizeof(e),1,file);*/
  /*while(fread(&e,sizeof(e),1,file)>0){
    fseek(file,-1*sizeof(e),SEEK_CUR);
    e.disponibilidade=1;
    fwrite(&e,sizeof(e),1,file);
   }    
  fseek(file,0,SEEK_SET);*/
  filo = fopen("enfermeiros.txt","r");
  file = fopen("datnovo.dat","wb");
  fread(&e,sizeof(e),1,filo);
  fwrite(&e,sizeof(e),1,file);
  fclose(file);
  fclose(filo);
  /*file = fopen("datnovo.dat","r+");
  filo = fopen("enfermeiros.txt","w");
  fread(&e,sizeof(e),1,file);
  fprintf(filo,"%d:%s:%s:%d:%d\n", e.ced_profissional,e.nome,e.CS_enfermeiro,e.num_vac_dadas,e.disponibilidade);
  fclose(file);
  fclose(filo);*/
  
  
}