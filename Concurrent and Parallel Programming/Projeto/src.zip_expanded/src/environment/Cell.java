package environment;

import game.Game;
import game.Player;

import java.io.Serializable;
import java.util.Observable;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

public class Cell implements Serializable {
	private Coordinate position;
	private Game game;
	private Player player=null;
	public ReentrantLock lock = new ReentrantLock();

	//TODO: REPENSAR O BUSY
	public Condition busy = lock.newCondition();
	public Cell(Coordinate position,Game g) {
		super();
		this.position = position;
		this.game=g;
	}

	public Coordinate getPosition() {
		return position;
	}

	public boolean isOcupied() {
		return this.player!=null;
	}


	public Player getPlayer() {
		return player;
	}

	// Should not be used like this in the initial state: cell might be occupied, must coordinate this operation
	public void setPlayer(Player player) {
		this.player = player;
		busy.signal();
	}

	@Override
	public String toString() {
		return "Cell " + position.toString() + " player: " + (player != null ? player.getId() : "null");
	}
}
