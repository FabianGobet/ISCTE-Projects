package game;

import java.io.*;
import java.net.Socket;

public abstract class Connection {

    protected Socket socket;

    protected void closeConnection() {
        try {
            socket.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
                /*
                FAZER HANDLE DO ERRO - SYSOUT
                 */
        }
    }

    abstract void getStreams() throws IOException;



}
