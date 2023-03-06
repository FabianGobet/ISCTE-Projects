package game;

import environment.Cell;
import environment.Coordinate;
import environment.Direction;
import gui.GameGuiMain;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class Server implements ConnectionConf{

    private ServerSocket serversocket;
    private GameGuiMain gameGui;

    protected ObjectOutputStream output;
    protected  BufferedReader input;
    public Server(){
        try {
            serversocket = new ServerSocket(ConnectionConf.PORT);
        } catch (IOException e) {
            System.out.println("Cannot initiate Server.\n"+ e);
            System.exit(1);
        }
    }

    public void runServer(){
        gameGui= new GameGuiMain("Server");
        gameGui.init();
        while(true){
            try {
                connect();
            } catch (IOException e) {
                throw new RuntimeException(e);
                /*
                FAZER HANDLE DO ERRO - SYSOUT
                 */
            }
        }
    }

    public void connect() throws IOException {
        System.out.println("Waiting for connections...");
        Socket connection = serversocket.accept();
        (new Thread(new ConnectionHandler(connection))).start();
    }

    private class ConnectionHandler extends Connection implements Runnable{
        Player player;
        public ConnectionHandler(Socket socket){
            this.socket=socket;
        }


        private class StateSender extends Thread{
            @Override
            public void run(){
                try {
                    while(true) {
                        //System.out.println(socket.isClosed());
                        Thread.sleep(500);
                        Cell[][] board = gameGui.getGame().getBoard();
                        /*
                        for(Cell[] l : board){
                            for(Cell c : l)
                                System.out.print((c.isOcupied()? c.getPlayer().getCurrentStrength():"-")+" ");
                            System.out.println();
                        }
                        System.out.println();
                        */
                        output.writeObject(board);
                        //System.out.println(socket.isClosed());
                        output.flush();
                        output.reset();
                        Thread.sleep(Game.REFRESH_INTERVAL);
                        //System.out.println(socket.isClosed()+"\n");
                    }
                } catch (InterruptedException e) {
                    System.out.println("Erro no handler da envio do board");
                } catch (IOException ex) {
                    throw new RuntimeException(ex);
                }
            }
        }

        //TODO: TRATAR EXCECAO CLIENTE FECHAR JANELA

        @Override
        public void run(){
            try {
                System.out.println("Connectado");
                player = new HumanPlayer(gameGui.getGame().getNextId(), gameGui.getGame());
                gameGui.getGame().addPlayerToGame(player);
                //getStreams();
                processConnection();
            } catch (IOException e) {
                /*
                FAZER HANDLE DO ERRO - SYSOUT
                 */
                throw new RuntimeException(e);
            } finally {
                closeConnection();
            }
        }

        private void processConnection() throws IOException {
            getStreams();
            (new StateSender()).start();
            while(true) {
                String inputDirection = input.readLine();
                System.out.println("Ja li" + inputDirection);
                if(input!=null){
                    Direction direction = Direction.valueOf(inputDirection);
                    Coordinate coord = player.getCurrentCell().getPosition().translate(direction.getVector());

                    System.out.println(player.getCurrentCell().toString());

                    if (gameGui.getGame().isInBounds(coord)) player.move(coord);

                    System.out.println(player.getCurrentCell().toString());
                    gameGui.getGame().notifyChange();
                }
            }
        }

        @Override
        void getStreams() throws IOException {
            output = new ObjectOutputStream(socket.getOutputStream());
            input = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        }
    }

    public static void main(String[] args) {
        Server s = new Server();
        s.runServer();

    }
}
