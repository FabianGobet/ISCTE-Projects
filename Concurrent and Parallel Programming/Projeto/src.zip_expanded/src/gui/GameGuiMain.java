package gui;

import java.io.Serializable;
import java.util.Observable;
import java.util.Observer;

import environment.Cell;
import game.Game;
import game.PhoneyHumanPlayer;

import javax.swing.JFrame;

public class GameGuiMain implements Observer {
	private JFrame frame = new JFrame("pcd.io");
	private BoardJComponent boardGui;
	private Game game;

	public GameGuiMain() {
		super();
		game = new Game();
		game.addObserver(this);
		buildGui();
	}

	//TODO: CONSIDERAR UM OVERLOAD MAIS EFICIENT (COM RECURSO AO CONSTRUTOR NAO OVERLOADED)
	public GameGuiMain(String title){
		super();
		frame.setTitle(title);
		game = new Game();
		game.addObserver(this);
		buildGui();
	}


	public BoardJComponent getBoardGui(){
		return boardGui;
	}



	public Game getGame(){
		return this.game;
	}

	public void buildGui() {
		//TODO: TER EM CONTA O ALTERNATIVE KEYS
		boardGui = new BoardJComponent(game,false);
		frame.add(boardGui);


		frame.setSize(800,800);
		frame.setLocation(0, 150);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	public void setFrameVisible(){
		frame.setVisible(true);
	}

	public void init()  {
		setFrameVisible();
		game.init();
	}

	@Override
	public void update(Observable o, Object arg) {
		boardGui.repaint();
	}

	public static void main(String[] args) {
		GameGuiMain game = new GameGuiMain();
		game.init();
	}

}
