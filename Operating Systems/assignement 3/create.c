#include "common.h"
#include "utils.h"
#include <signal.h>

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>

int main() {
    int id = msgget( IPC_KEY, IPC_CREAT | 0666 );
    exit_on_error(id, "Erro no msgget");
    printf("Estou a usar a fila de mensagens id=%d\n", id);

    return(0);
}