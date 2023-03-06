package game;

import environment.Cell;
import environment.Coordinate;

import java.util.List;
import java.util.Observable;
import java.util.Random;
import java.util.concurrent.locks.Lock;

/**
 * Class to demonstrate a player being added to the game.
 * @author luismota
 *
 */
public class PhoneyHumanPlayer extends Player {
	public PhoneyHumanPlayer(int id, Game game) {
		super(id, game);
	}

	public boolean isHumanPlayer() {
		return false;
	}

	protected synchronized void move(Coordinate coord) {
		Cell nextCell = game.getCell(coord);
		Cell currentCell = getCurrentCell();
		currentCell.lock.lock();
		nextCell.lock.lock();

		try {
			if (nextCell.isOcupied()) {

				Player hostile = nextCell.getPlayer();

				if (!hostile.isObstacle()) {
					fight(hostile);
				} else {
					currentCell.busy.signal();
					currentCell.lock.unlock();
					while(nextCell.isOcupied()){
						//WAIT????
						nextCell.busy.await();
					}
				}

			} else {
				currentCell.setPlayer(null);
				nextCell.setPlayer(this);
			}
		}catch (InterruptedException e){
			nextCell.lock.unlock();
			return;
		}

		nextCell.busy.signal();
		currentCell.busy.signal();
		currentCell.lock.unlock();
		nextCell.lock.unlock();
		game.notifyChange();

	}
}
