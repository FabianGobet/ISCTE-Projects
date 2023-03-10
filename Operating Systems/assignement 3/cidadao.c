/******************************************************************************
 ** ISCTE-IUL: Trabalho prático 3 de Sistemas Operativos
 **
 ** Aluno: Nº:       Nome: 
 ** Nome do Módulo: cidadao.c
 ** Descrição/Explicação do Módulo: 
 **
 **
 ******************************************************************************/
#include "common.h"
#include "utils.h"
#include <signal.h>

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <unistd.h>

/* Variáveis globais */
int msg_id;             // ID da Fila de Mensagens usada
MsgCliente mensagem;    // Variável que tem a mensagem enviada do Cidadao para o Servidor
MsgServidor resposta;   // Variável que tem a mensagem de resposta enviadas do Servidor para o Cidadao

/* Protótipos de funções */
void init_ipc();                    // Função a ser implementada pelos alunos
void cria_mensagem();               // Função a ser implementada pelos alunos
void envia_mensagem_servidor();     // Função a ser implementada pelos alunos
void espera_resposta_servidor();    // Função a ser implementada pelos alunos
void trata_resposta_servidor();     // Função a ser implementada pelos alunos
void vacina();                      // Função a ser implementada pelos alunos
void cancela_pedido(int);           // Função a ser implementada pelos alunos
void print_info(Cidadao cidadao);

int main() {    // Não é suposto que os alunos alterem nada na função main()
    // C1) Chama a função init_ipc(), que tenta abrir uma fila de mensagens IPC que tem a KEY IPC_KEY definida em common.h (alterar esta KEY para ter o valor do nº do aluno, como indicado nas aulas). Deve assumir que a fila de mensagens já foi criada. Se tal não aconteceu, dá erro e termina com exit status 1. Esta função, em caso de sucesso, preenche a variável global msg_id;
    init_ipc();
    // C2) Chama a função cria_mensagem()
    cria_mensagem();
    // C3) Envia um pedido de consulta de vacinação para o processo Servidor, chamando a função envia_mensagem_servidor(), que envia uma mensagem para a fila de mensagens com tipo 1, com pedido = PEDIDO e os dados do cidadão; em caso de erro, termina com erro e exit status 1.
    envia_mensagem_servidor();
    // C7) Arma e trata o sinal SIGINT (só pode acontecer depois do passo C3) para que, quando o utilizador interromper o processo Cidadão com <CTRL+C>, chame a função cancela_pedido()
    signal(SIGINT, cancela_pedido);
    // C4) Chama a função espera_resposta_servidor(), que espera a resposta do processo Servidor (na fila de mensagens com o tipo = PID_Cidadao) e preenche a mensagem enviada pelo processo Servidor na variável global resposta; em caso de erro, termina com erro e exit status 1.
    espera_resposta_servidor();
    // C5) O comportamento do processo Cidadão agora irá depender da resposta enviada pelo processo Servidor no campo status:
    trata_resposta_servidor();
    // C6) Inicia o processo de vacinação
    vacina();
}

/**
 * C1) tenta abrir uma fila de mensagens que tem a KEY IPC_KEY
 * definida em common.h (alterar esta KEY para ter o valor do nº do aluno, como indicado nas aulas).
 * Deve assumir que a fila de mensagens já foi criada.
 * Se tal não aconteceu, dá erro e termina com exit status 1.
 * Esta função, em caso de sucesso, preenche a variável global msg_id;
 */
void init_ipc() {
    debug("<");
    msg_id = msgget(IPC_KEY,0);
    exit_on_error(msg_id,"init_ipc) Fila de Mensagens com a Key definida não existe ou não pode ser aberta");
    sucesso("C1) Fila de Mensagens com a Key %x aberta com o ID %d", IPC_KEY, msg_id);
    // Outputs esperados (os itens entre <> deverão ser substituídos pelos valores correspondentes):
    // exit_on_error(<var>, "init_ipc) Fila de Mensagens com a Key definida não existe ou não pode ser aberta");
    // sucesso("C1) Fila de Mensagens com a Key %x aberta com o ID %d", IPC_KEY, msg_id);
    debug(">");
}

/**
 * C2.1) Pede ao Cidadão (utilizador) os seus dados, nomeadamente o número de utente e nome, obrigatoriamente nessa ordem, preenchendo os dados na variável global mensagem;
 * C2.2) Preenche os campos PID_cidadao da variável global mensagem com o PID deste processo Cidadão, tipo da mensagem com o tipo 1, e pedido = PEDIDO;
 */
void cria_mensagem() {
    debug("<");
    printf("Introduza o seu numero de utente: ");
    scanf("%d",&mensagem.dados.num_utente);
    printf("Introduza o seu nome: ");
    my_gets(mensagem.dados.nome,99);
    sucesso("C2.1) Dados Cidadão: %d, %s", mensagem.dados.num_utente,mensagem.dados.nome);
    // C2.1) Pede ao Cidadão (utilizador) os seus dados, nomeadamente o número de utente e nome, obrigatoriamente nessa ordem, preenchendo os dados na variável global mensagem;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C2.1) Dados Cidadão: %d, %s", <num_utente>, <nome>);
    debug(".");
    mensagem.dados.PID_cidadao=getpid();
    mensagem.tipo=1;
    mensagem.dados.pedido=PEDIDO;
    sucesso("C2.2) PID Cidadão: %d", mensagem.dados.PID_cidadao);
    // C2.2) Preenche os campos PID_cidadao da variável global mensagem com o PID deste processo Cidadão, tipo da mensagem com o tipo 1, e pedido = PEDIDO;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C2.2) PID Cidadão: %d", <PID_Cidadao>);
    debug(">");
}

/**
 * Envia a mensagem para a fila de mensagens; em caso de erro no envio, termina com erro e exit status 1.
 */
void envia_mensagem_servidor() {
    debug("<");
    int status = msgsnd(msg_id,&mensagem,sizeof(mensagem.dados),0);
    exit_on_error(status,"Não é possível enviar mensagem para o servidor");
    sucesso("Mensagem para o servidor enviada");
    // C3) Envia uma mensagem para a fila de mensagens com tipo 1, com pedido = PEDIDO e os dados do cidadão; em caso de erro, termina com erro e exit status 1.
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // exit_on_error(<var>, "Não é possível enviar mensagem para o servidor");
    // sucesso("Mensagem para o servidor enviada");
    debug(">");
}

/**
 * Espera a resposta do processo Servidor (na fila de mensagens com o tipo = PID_Cidadao) e preenche a mensagem enviada pelo processo Servidor na variável global resposta; 
 */
void espera_resposta_servidor() {
    debug("<");
    int status = msgrcv(msg_id,&resposta,sizeof(resposta.dados),mensagem.dados.PID_cidadao,0);
    exit_on_error(status, "espera_resposta_servidor) Não é possível ler a resposta do servidor");
    sucesso("Servidor enviou resposta");
    // Espera a resposta do processo Servidor (na fila de mensagens com o tipo = PID_Cidadao) e preenche a mensagem enviada pelo processo Servidor na variável global resposta; 
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // exit_on_error(<var>, "espera_resposta_servidor) Não é possível ler a resposta do servidor");
    // sucesso("C4) Servidor enviou resposta");
    debug(">");
}

/**
 * C5) Trata a resposta do processo Servidor, usando a variável global resposta
 */
void trata_resposta_servidor() {
    debug("<");
    if(resposta.dados.status==DESCONHECIDO){
      erro("C5.1) Não existe registo do utente %d, %s", mensagem.dados.num_utente, mensagem.dados.nome);
      exit(1);
    }
    // C5.1) Se o estado for DESCONHECIDO, imprime uma mensagem de erro, e termina com exit status 1;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // erro("C5.1) Não existe registo do utente %d, %s", <num_utente>, <nome>);
    else if(resposta.dados.status==VACINADO){
      sucesso("C5.2) O utente %d, %s foi vacinado", mensagem.dados.num_utente, mensagem.dados.nome);
      exit(0);
    }
    debug(".");
    // C5.2) Se o estado for VACINADO, imprime uma mensagem de sucesso, e termina com exit status 0;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C5.2) O utente %d, %s foi vacinado", <num_utente>, <nome>);
    else if(resposta.dados.status==EMCURSO){
      sucesso("C5.3) A vacinação do utente %d, %s já está em curso", mensagem.dados.num_utente, mensagem.dados.nome);
      exit(0);
    }
    debug(".");
    // C5.3) Se o estado for EMCURSO, imprime uma mensagem de sucesso, e termina com exit status 0;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C5.3) A vacinação do utente %d, %s já está em curso", <num_utente>, <nome>);
    else if(resposta.dados.status==AGUARDAR){
      sucesso("C5.4) Utente %d, %s, por favor aguarde...", mensagem.dados.num_utente, mensagem.dados.nome);
      sleep(TEMPO_ESPERA);
      envia_mensagem_servidor();
    }
    debug(".");
    // C5.4) Se o estado for AGUARDAR, imprime uma mensagem de sucesso, aguarda (sem espera ativa!) um tempo correspondente a TEMPO_ESPERA segundos, e depois retorna ao ponto C3;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C5.4) Utente %d, %s, por favor aguarde...", <num_utente>, <nome>);
    else if(resposta.dados.status==OK){
      sucesso("C5.5) Utente %d, %s, vai agora ser vacinado", mensagem.dados.num_utente, mensagem.dados.nome);
      vacina();
    }
    debug(".");
    // C5.5) Se o estado for OK, imprime uma mensagem de sucesso, e depois vai para o ponto C6.
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C5.5) Utente %d, %s, vai agora ser vacinado", <num_utente>, <nome>);
    debug(">");
}

/**
 * Imprime informação sobre o utente
 * @param cidadao Cidadao a reportar
 **/
void print_info(Cidadao cidadao) {
    debug("<");
    printf("Número de utente: %d\n", cidadao.num_utente);
    printf("Nome            : %s\n", cidadao.nome);
    printf("Idade           : %d ano%s\n", cidadao.idade, cidadao.idade > 1 ? "s" : "");
    printf("Localidade      : %s\n", cidadao.localidade);
    printf("N.º Telemóvel   : %s\n", cidadao.nr_telemovel);
    printf("Vacina          : %dª dose\n", cidadao.estado_vacinacao + 1);
    debug(">");
}

/**
 * Espera a resposta do processo Servidor (na fila de mensagens com o tipo = PID_Cidadao) e preenche a mensagem enviada pelo processo Servidor na variável global resposta; 
 */
void vacina() {
    debug("<");
    sucesso("C6.1) Dados completos sobre o cidadão a ser vacinado");
    print_info(resposta.dados.cidadao);
    // C6.1) Chama a função print_info(cidadao) com a informação recebida na resposta do processo Servidor, que irá imprimir a informação completa sobre o cidadão que vai ser vacinado;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C6.1) Dados completos sobre o cidadão a ser vacinado");
    // print_info(...);
    espera_resposta_servidor();
    // C6.2) Chama novamente a função espera_resposta_servidor(), que espera uma nova resposta do processo Servidor (na fila de mensagens com o tipo = PID_Cidadao) e preenche a mensagem enviada pelo processo Servidor na variável global resposta;
    
    // C6.3) O comportamento do processo Cidadão agora irá depender da resposta enviada pelo processo Servidor no campo status:
    if(resposta.dados.status==OK){
      sucesso("C6.3.1) Utente %d, %s vacinado com sucesso",mensagem.dados.num_utente, mensagem.dados.nome);
      exit(0);
    }
    // C6.3.1) Se o estado for OK, imprime uma mensagem de sucesso, e termina com exit status 0;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C6.3.1) Utente %d, %s vacinado com sucesso", <num_utente>, <nome>);
    else{
      erro("C6.3.2) O servidor cancelou a vacinação em curso");
      exit(1);
    }
    // C6.3.2) Se o estado não for OK, imprime uma mensagem de erro, e termina com exit status 1;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // erro("C6.3.2) O servidor cancelou a vacinação em curso");

    debug(">");
}

/**
 * C7) Quando o utilizador interromper o processo Cidadão com <CTRL+C>:
 * C7.1) Escreve no ecrã uma mensagem;
 * C7.2) Envia para o processo Servidor uma mensagem (com o tipo 1), com pedido = CANCELAMENTO e os dados do cidadão;
 * C7.3) Chama novamente a função espera_resposta_servidor(), que espera uma nova resposta do processo Servidor (na fila de mensagens com o tipo = PID_Cidadao) e preenche a mensagem enviada pelo processo Servidor na variável global resposta;
 * C7.4) O comportamento do processo Cidadão agora irá depender da resposta enviada pelo processo Servidor no campo status:
 * C7.4.1) Se o estado for CANCEL, imprime uma mensagem de erro, e termina com exit status 1;
 * C7.4.2) Se o estado for TERMINADA, imprime mensagem sucesso, termina com exit status 0;
 */
void cancela_pedido(int sinal) {
    debug("<");
    sucesso("C7.1) O cidadão cancelou a vacinação no processo %d", mensagem.dados.PID_cidadao); 
    // C7.1) Escreve no ecrã uma mensagem;
    // Outputs esperados (os itens entre <> deverão ser substituídos pelos valores correspondentes):
    // sucesso("C7.1) O cidadão cancelou a vacinação no processo %d", <PID_Cidadao>);

    debug(".");
    mensagem.dados.pedido=CANCELAMENTO;
    // C7.2) Altera a variável global mensagem, tornando pedido = CANCELAMENTO. Chama a função envia_mensagem_servidor(), que envia a mensagem para a fila de mensagens; em caso de erro no envio, afixa uma mensagem de erro e termina com exit status 1;
    envia_mensagem_servidor();

    debug(".");
    // C7.3) Chama novamente a função espera_resposta_servidor(), que espera uma nova resposta do processo Servidor (na fila de mensagens com o tipo = PID_Cidadao) e preenche a mensagem enviada pelo processo Servidor na variável global resposta;
    espera_resposta_servidor();

    debug(".");
    // C7.4) O comportamento do processo Cidadão agora irá depender da resposta enviada pelo processo Servidor no campo status:
    if(resposta.dados.status==CANCEL){
      sucesso("C7.4.1) Servidor confirmou cancelamento");
      exit(0);
    }

    debug(".");
    // C7.4.1) Se o estado for CANCEL, imprime uma mensagem de sucesso, e termina com exit status 0;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C7.4.1) Servidor confirmou cancelamento");
    else if(resposta.dados.status==TERMINADA){
      sucesso("C7.4.1) Servidor confirmou cancelamento");
      exit(0);
    }
    debug(".");
    // C7.4.2) Se o estado for TERMINADA, imprime mensagem sucesso, termina com exit status 0;
    // Outputs esperados (itens entre <> substituídos pelos valores correspondentes):
    // sucesso("C7.4.2) A vacinação já tinha sido concluída");

    debug(">");
}