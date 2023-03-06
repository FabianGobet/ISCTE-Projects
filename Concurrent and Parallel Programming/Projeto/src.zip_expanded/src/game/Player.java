package game;



import environment.Cell;
import environment.Coordinate;
import environment.Direction;

import java.io.Serializable;
import java.util.List;
import java.util.Observable;
import java.util.Observer;
import java.util.Random;
import java.util.concurrent.CountDownLatch;

/**
 * Represents a player.
 * @author luismota
 *
 */
public abstract class Player extends Thread implements Serializable {


	protected  Game game;
	private int id;
	private byte currentStrength;
	private final byte originalStrength;

	public Cell getCurrentCell() {
		for(Cell[] c : game.board)
			for(Cell c2 : c){
				c2.lock.lock();
				if(c2.isOcupied() && c2.getPlayer().equals(this)){
					c2.lock.unlock();
					return c2;
				}
				c2.lock.unlock();
			}

		return null;
	}


	public Player(int id, Game game) {
		super();
		this.id = id;
		this.game=game;
		originalStrength = (byte)Game.generateInitialStrength();
		currentStrength = originalStrength;
	}

	public Player(int id, Game game, byte strength){
		super();
		this.id = id;
		this.game=game;
		originalStrength = strength;
		currentStrength = strength;
	}

	public abstract boolean isHumanPlayer();

	@Override
	public String toString() {
		return "Player [id=" + id + ", currentStrength=" + currentStrength + ", getCurrentCell()=" + getCurrentCell()
		+ "]";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Player other = (Player) obj;
		if (id != other.id)
			return false;
		return true;
	}

	public byte getCurrentStrength() {
		return currentStrength;
	}


	public int getIdentification() {
		return id;
	}


	protected abstract void move(Coordinate dir);

	public boolean isObstacle(){
		return (currentStrength<=0 || currentStrength>=10);
	}


	//TODO: ESTE RUN TEM DE ESTAR NO PHONEYHUMAN
	@Override
	public void run() {
		game.addPlayerToGame(this);
		try {
			Thread.sleep(Game.INITIAL_WAITING_TIME);
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
		while (!game.isFinished() && currentStrength > 0 && currentStrength < 10){
			Player thisPlayer = this;
			Thread interrupter = (new Thread(() -> {
				try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					return;
				}
				thisPlayer.interrupt();

			}));
			interrupter.start();

			List<Coordinate> possibleMoves = game.getAdjacentCells(getCurrentCell());
			Coordinate randomCoord = possibleMoves.get((new Random()).nextInt(possibleMoves.size()));
			move(randomCoord);
			interrupter.interrupt();

			try {
				Thread.sleep(Game.MAX_WAITING_TIME_FOR_MOVE * originalStrength);
			} catch (InterruptedException e) {
				throw new RuntimeException(e);
			}
		}
	}

	public void addStrength(byte s){
		currentStrength += s;
		currentStrength = (byte)Math.min(currentStrength, 10);
		if(currentStrength==10){
			Game.cdl.countDown();
		}
	}

	protected void fight(Player p){
		if(this.getCurrentStrength() > p.getCurrentStrength())
			kill(p);

		else if (this.getCurrentStrength() < p.getCurrentStrength())
			p.kill(this);

		else if (Math.random() < 0.5) kill(p); else p.kill(this);
	}

	private void kill(Player victim){
		this.addStrength(victim.getCurrentStrength());
		victim.currentStrength=0;
	}

}
