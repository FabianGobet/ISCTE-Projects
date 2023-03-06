package game;

import environment.Cell;
import environment.Direction;
import gui.GameGuiMain;

import java.io.*;
import java.net.InetAddress;
import java.net.Socket;


public class Client extends Connection implements ConnectionConf{

    private String hostname;
    protected PrintWriter output;
    protected ObjectInputStream input;
    private GameGuiMain gameGui;
    //private Game game;

    public Client(String hostname){
        super();
        this.hostname=hostname;
    }

    public void runClient(){
        try {
            connect();
            gameGui = new GameGuiMain("Cliente");
            gameGui.setFrameVisible();
            processConnection();
        } finally {
            closeConnection();
        }

    }

    private class KeyLookout extends Thread{
         @Override
        public void run() {
             while (true) {
                 Direction dir = gameGui.getBoardGui().getLastPressedDirection();
                 System.out.println(dir);
                 if (dir != null) {
                     System.out.println(dir);
                     //System.out.println(socket.isClosed());
                     output.println(dir);
                     gameGui.getBoardGui().clearLastPressedDirection();
                 }
             }
         }
    }

    private void processConnection(){
        getStreams();
        Cell[][] board;
        try {
            System.out.println("First input: "+input.available());
            board = (Cell[][]) input.readObject();

            (new KeyLookout()).start();
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        while (true) {
                try {
                    Thread.sleep(1000);
                    board = (Cell[][]) input.readObject();
                    gameGui.getGame().setBoard(board);
                    gameGui.getGame().notifyChange();
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                } catch (ClassNotFoundException e) {
                    throw new RuntimeException(e);
                }
        }

    }

    public void connect(){
        try {
            socket = new Socket(InetAddress.getByName(hostname),Server.PORT);
        } catch (IOException e) {
            System.out.println("Error connecting to server... aborting!\n+e");
            System.exit(1);
        }
    }

    public static void main(String[] args) {
        Client c = new Client(null);
        c.runClient();
    }

    @Override
    void getStreams()  {
        try {
            //System.out.println(1);
            input = new ObjectInputStream(socket.getInputStream());
            //System.out.println(2);
            output = new PrintWriter (socket.getOutputStream(),true);
            //System.out.println(3);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
