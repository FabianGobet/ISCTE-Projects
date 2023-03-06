/******************************************************************************
 ** ISCTE-IUL: Trabalho prático de Sistemas Operativos
 **
 ** Aluno: Nº: 97885      Nome: Fabian Flores Gobet
 ** Nome do Módulo: servidor.c
 ** Descrição/Explicação do Módulo: 
 ** -A descrição do modulo é feita através de comentarios ao longo do código.
 **
 ******************************************************************************/
#include "common.h"

#include <unistd.h> 
#include <stdlib.h>
#include <signal.h> // biblioteca necessária para fazer o uso de sinais
#include <sys/wait.h> // biblioteca necessária para fazer uso da funçao wait()

Vaga vagas[NUM_VAGAS];
FILE *file;
char buffer[100];
Enfermeiro e;
int nr_enfermeiros=0;
Enfermeiro *enfermeiros;
int nr_vacinas=0; //esta variavel representa o numero de vacinas que estao a ser administradas a cada tempo. desta forma não é necessario percorrer sempre o array de vagas todo para ver se existe vaga. 


void trata_sinal(int sinal){ // Esta função trata todos os sinais recebidos

  if(sinal==17){ //SIGCHLD
    int pid_novo; 
    pid_novo=wait(NULL); //cria uma variavel do tipo int onde vai guardar o PID do processo que mandou o sinal SIGCHLD
    for(int i=0; i< NUM_VAGAS; i++) // vai iterar sobre o array de vagas, para encontrar o indice da vaga que tem o PID recebido
      if(vagas[i].PID_filho == pid_novo){
        int old_index=vagas[i].index_enfermeiro; //grava o indice do enfermeiro no array em memoria de enfermeiros
        vagas[i].index_enfermeiro=-1; // mete o campo indice de enfermeiros no array de vagas a -1, que significa disponivel
        nr_vacinas--; // decrementa uma unidade ao numero de vacinas que estao a ser dadas
        sucesso("S5.5.3.1) Vaga %d que era do servidor dedicado %d libertada.",i,pid_novo);
        enfermeiros[old_index].disponibilidade=1; // mete o enfermeiro que tem o indice gravado com disponibilidade 1
        sucesso("S5.5.3.2) Enfermeiro %d atualizado para disponivel.",old_index);
        enfermeiros[old_index].num_vac_dadas++; // incremente 1 ao numero de vacinas dadas por esse enfermeiro
        sucesso("S5.5.3.3) Enfermeiro %d atualizado para %d vacinas dadas.", old_index,enfermeiros[old_index].num_vac_dadas);
        if(!(file = fopen(FILE_ENFERMEIROS,"r+"))){
          erro("S5.5.3.4.1) Não foi possivel atualizar o ficheiro %s.", FILE_ENFERMEIROS); // EXTRA: mensagemde erro caso nao consiga abrir o ficheiro dat para atualizar o enfermeiro
          return;
        }
        fseek(file,old_index*sizeof(e),SEEK_SET); // vai para o sitio no cheiro onde esta o enfermeiro com o indice guardado
        fread(&e,sizeof(e),1,file);  //faz a leitura para a variavel 'e', do tipo enfermeiro
        e.num_vac_dadas++; // incremente em 'e' o numero vacinas dadas
        fseek(file,-1*sizeof(e),SEEK_CUR); //o fread faz o ponteiro file andar uma unidade de enfermeiros para a frente, entao para reescrever é preciso andar uma unidade para traz
        fwrite(&e,sizeof(e),1,file); //escreve a informação de 'e' no devido lugar
        fclose(file);
        sucesso("S5.5.3.4)Ficheiro %s, enfermeiro index %d atualizado para %d vacinas dadas.",FILE_ENFERMEIROS,old_index,enfermeiros[old_index].num_vac_dadas);
        sucesso("S5.5.3.5) Retorna");
        return;
      }
  }

  if(sinal==15){ //SIGTERM
    for(int i=0; i<NUM_VAGAS; i++){ // o sinal SIGTERM é recebido pelos processos filhos. 
      if(vagas[i].PID_filho == 0){ // no array de vagas, onde PID_filho é igual a zero, ou seja,  a vaga relacioanda com o respetivo processo filho, vai buscar o PID_cidadao e termina-lo. e termina-se a si proprio tbm
        sucesso("S5.6.1) SIGTERM recebido, servidor dedicado termina cidadão %d.",vagas[i].cidadao.PID_cidadao);
        kill(vagas[i].cidadao.PID_cidadao, SIGTERM);
        exit(0);
      }
    }
  }
  
  if(sinal==2){ //SIGINT
    for(int i=0; i<NUM_VAGAS; i++) // ao receber o sinal SIGINT, vai ver todas as vagas ocupadas e termina os processos filhos associados
      if(vagas[i].index_enfermeiro!=-1){ 
        kill(vagas[i].PID_filho,SIGTERM); 
      }
    if(fork()==0)
      execl("/bin/rm","rm","-f",FILE_PID_SERVIDOR,NULL); //d e seguida faz um fork para remover o ficheiro servidor.pid
    wait(NULL); // espera que o filho termine
    sucesso("Servidor terminado.");
    exit(0); //termina o servidor
  }
    
  if(sinal==10){ //SIGUSR1  
    Cidadao cid; // variavel cidadao onde vai guardar as informações lidas no ficheiro pedidovacina.txt
    if(access("./pedidovacina.txt",F_OK) ==0){ //ve se o da para abrir
      if(access("./pedidovacina.txt",R_OK)==0){//ve se o ficheiro da para ler
        file = fopen(FILE_PEDIDO_VACINA,"r"); // em caso afirmativo abre, e faz um fscanf guardado os valores segundo a formatação nos campos do cidadao
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
    for(int i=0; i<=nr_enfermeiros; i++){ // este for vai correr o array de enfermeiros
      char cid_local[102]="CS"; // cria uma string com "CS" no inicio para depois faze4r comparaçao com localidade do enfermeiro
      strcat(cid_local,cid.localidade); // concatenaçao da string com "CS" com a string do cidadao que contem apenas o nome da localidade, e guarda em cid_local
      if((strcmp(enfermeiros[i].CS_enfermeiro,cid_local))==0){ //procura o enfermeiro cujo o campo localidade corresponde com o de cid_local
        if(enfermeiros[i].disponibilidade==0){ //apos encontrar ve se nao esta disponivel, e em caso afirmativo mostra mensagem e manda o respetivo sinal ao processo cidadao
          erro("S5.2.1) Enfermeiro %d indisponível para o pedido %d para o Centro de Saúde %s.",i,cid.PID_cidadao,cid.localidade);
          kill(cid.PID_cidadao,SIGTERM);
          return;
        }
        sucesso("S5.2.1) Enfermeiro %d disponível para o pedido %d.",i,cid.PID_cidadao);   
        if(nr_vacinas<NUM_VAGAS){ //caso esteja disponivel, vai averiguar se existe vaga usando o nr_vacinas, que representa o nr_vacinas a serem administradas naquele preciso momento
          sucesso("S5.2.2) Há vaga para a vacinação para o pedido %d.", cid.PID_cidadao);
          nr_vacinas++; //caso haja vaga, incrementa um valor a nr_vacinas para guardar esse lugar
          for(int j=0; j<NUM_VAGAS; j++){ // de seguida vai correr o array de vagas para ver qual é a que esta disponivel e define os atributos relativos a essa vaga
            if(vagas[j].index_enfermeiro==-1){ 
              vagas[j].index_enfermeiro=i;
              vagas[j].cidadao=cid;
              enfermeiros[i].disponibilidade=0; //o enfermeiro passa a indisponivel
              sucesso("S5.3) Vaga nº %d preenchida para o pedido %d.", j,cid.PID_cidadao);
              int pid_son=fork(); // faz um fork e guarda o valor do PID do filho
              if(pid_son==-1){ //se o valor do pid for -1 quer dizer que o fork falhou, entao mostra mensagem e termina o processo cidadao
                erro("S5.4) Não foi possivel criar o servidor dedicado.");
                kill(cid.PID_cidadao,SIGTERM);
                return;
              } else if(pid_son==0){ // caso o fork se dê e seja o processo filho
                sucesso("S5.4) Servidor dedicado %d criado para %d.", getpid(),cid.PID_cidadao);
                signal(SIGTERM,trata_sinal); // arma o sinal SIGTERM caso o servidor-pai receba um SIGINT
                kill(vagas[j].cidadao.PID_cidadao, SIGUSR1); //avisa o processo cidadao que o cidadao iniciou a vacinacao com o sinal SIGUSR1
                sucesso("S5.6.2) Servidor dedicado inicia consulta de vacinação.");
                sleep(TEMPO_CONSULTA); //espera o tempo de consulta
                sucesso("S5.6.3) Vacinação terminada para o cidadao com pedido nº %d.", vagas[j].cidadao.PID_cidadao);
                kill(vagas[j].cidadao.PID_cidadao, SIGUSR2); // manda sinal ao processo cidadao a avisar que o cidadao terminou a vacinaçao
                sucesso("S5.6.4) Servidor dedicado termina consulta de vacinação.");
                exit(0); // processo-filho termina
              } else { //no caso do processo pai
              vagas[j].PID_filho=pid_son; //guarda o pid do filho no respetivo atributo do respetivo lugar em vagas
              sucesso("S5.5.1) Servidor dedicado %d na vaga %d.", pid_son,j);
              signal(SIGCHLD,trata_sinal); // arma o sinal SIGCHLD para saber quando o filho termina a vacinaçao
              sucesso("S5.5.2) Servidor aguarda fim do servidor dedicado %d.", pid_son);
              return;
              }
            }
          }
        }
        erro("S5.2.2) Não há vaga para vacinação para o pedido %d",cid.PID_cidadao); // caso nr_vacinas>= NUM_VAGAS
        kill(cid.PID_cidadao,SIGTERM); //manda SIGTERM ao processo cidadao a informar que nao é possivel vacinar de momento
        return;
      }
    }
    erro("S5.1.1) Não existem centros de saude com o nome %s.",cid.localidade); // se na conclusao do for nao tiver havido nenhuma correspondendia entre as localidades, quer dizer na localidade nao ha centro de saude listado   
    kill(cid.PID_cidadao,SIGTERM); //manda SIGTERM ao processo cidadao a informar que nao é possivel vacinar de momento 
    return;
  }
}

int main () {
    
  if((file = fopen(FILE_PID_SERVIDOR,"w"))==NULL){ //caso falhe a abrir para reescrever, ou a criar o ficheiro servidor.pid
    erro("S1) Não consegui registar o servidor."); //mostra uma mensagem e termina o processo
    exit(0);
  }
  fprintf(file,"%d",getpid()); // caso contrario escreve no ficheiro o proprio pid e guarda
  fclose(file);
  sucesso("S1) Escrevi no ficheiro %s o PID: %d",FILE_PID_SERVIDOR,getpid());

  
  if(!(file = fopen(FILE_ENFERMEIROS,"r"))){ // caso nao consiga abrir para ler o ficheiro enfermeiros.dat
    erro("S2) Não consegui ler o ficheiro %s.", FILE_ENFERMEIROS); // mostra mensagem de erro e termina o processo servidor
    exit(0);
  } 
  
  nr_enfermeiros=0; // mete nr enfermeiros a 0
  while(fread(&e,sizeof(e),1,file)>0)
    nr_enfermeiros++; //vai ler quantos enfermeiros existem no ficheiro.dat
  fclose(file);  
  
  sucesso("S2) O ficheiro %s tem tamanho %d bytes, ou seja %d enfermeiros.",FILE_ENFERMEIROS,nr_enfermeiros*sizeof(e),nr_enfermeiros);
  enfermeiros=malloc(nr_enfermeiros*sizeof(Enfermeiro)); //aloca memoria suficiente para fazer a estrutura de dados dinamica de enfermeiros em memoria
  file = fopen(FILE_ENFERMEIROS,"r");
  int count=0; // esta variavel vai indexando na estrutura criada os enfermeiros lidos no ficheiro enfermeiros.dat
  while(fread(&e,sizeof(e),1,file)>0) // le enquanto nao chegar ao fim do ficheiro e guarda os dados na variavel 'e' do tipo Enfermeiro
    enfermeiros[count++]=e; // incrementa count apos usar o index
  fclose(file);
  

  for(int i=0; i<NUM_VAGAS; i++) // mete todas as vagas do array de vagas disponiveis, metendo o parametro index_enfermeiro a -1
    vagas[i].index_enfermeiro=-1;
  sucesso("S3) Iniciei a lista de %d vagas.",NUM_VAGAS);
    
  signal(SIGUSR1, trata_sinal);
  signal(SIGINT, trata_sinal); //arma os sinais SIGINT e SIGUSR1 caso o servidor seja terminado e caso receba um pedido de vacina, respetivavmente
  while(1){
    sucesso("S4) Servidor espera pedidos."); // aguarda em espera passiva
    pause();
  }
    
}