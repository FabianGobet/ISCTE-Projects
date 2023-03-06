package game;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Observable;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import environment.Cell;
import environment.Coordinate;

public class Game extends Observable implements Serializable {

	public static final int DIMY = 10;
	public static final int DIMX = 10;
	private static final int NUM_PLAYERS = 1;
	private static final int NUM_FINISHED_PLAYERS_TO_END_GAME=3;

	public static final long REFRESH_INTERVAL = 400;
	public static final double MAX_INITIAL_STRENGTH = 3;
	public static final long MAX_WAITING_TIME_FOR_MOVE = 500;
	public static final long INITIAL_WAITING_TIME = 2000;
	public static final CountDownLatch cdl = new CountDownLatch(NUM_FINISHED_PLAYERS_TO_END_GAME);
	protected Cell[][] board;
	private final AtomicInteger nextId = new AtomicInteger(0);

	public Game() {
		board = new Cell[Game.DIMX][Game.DIMY];
	
		for (int x = 0; x < Game.DIMX; x++) 
			for (int y = 0; y < Game.DIMY; y++) 
				board[x][y] = new Cell(new Coordinate(x, y),this);
	}

	public Game(Cell[][] board) {
		this.board = board;
	}
	
	/** 
	 * @param player 
	 */
	public void addPlayerToGame(Player player) {
		Cell selectedCell = getRandomCell();
		//TODO: Pensar numa maneira para fazer o que se faz com o timeout de 2 segundos quando se tenta mover para uma celula com obstaculo
		putPlayer(player, selectedCell);

		// To update GUI
		notifyChange();
	}

	 public int getNextId(){
			return nextId.incrementAndGet();
	 }

	public synchronized void init(){

		for (int i = 0; i < NUM_PLAYERS; i++) {
			(new PhoneyHumanPlayer(getNextId(), this)).start();
		}


		(new Thread(() -> {
			try {
				cdl.await();
				System.out.println("Acabou");
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		})).start();

	}

	public Cell getCell(Coordinate at) {
		return board[at.x][at.y];
	}

	public boolean isInBounds(Coordinate coord){
		return !(0>coord.x || coord.x>Game.DIMX-1 || 0> coord.y || coord.y>Game.DIMY-1);
	}
	/**	
	 * Updates GUI. Should be called anytime the game state changes
	 */
	public void notifyChange() {
		setChanged();
		notifyObservers();
	}

	public Cell getRandomCell() {
		Cell newCell=getCell(new Coordinate((int)(Math.random()*Game.DIMX),(int)(Math.random()*Game.DIMY)));
		return newCell; 
	}

	public static int generateInitialStrength(){
		Random r = new Random();
		int low = 1; //inclusive
		int high = (int)MAX_INITIAL_STRENGTH  + 1; //exclusive
		return r.nextInt(high-low) + low;
	}

	public List<Coordinate> getAdjacentCells(Cell cell){
		List<Coordinate> list = new ArrayList<>();
		Coordinate center = cell.getPosition();
		for(int i=-1; i<2;i+=2) {
			if (0 <= center.x + i && center.x + i < DIMX) list.add(new Coordinate(center.x + i, center.y));
			if (0 <= center.y + i && center.y + i < DIMX) list.add(new Coordinate(center.x, center.y + i));
		}
		return list;
	}

	public boolean isFinished(){
		return cdl.getCount() == 0;
	}


	public void putPlayer(Player p, Cell cell){
		cell.lock.lock();
		try {
			while(cell.isOcupied()){
				System.out.println("PutPlayer: Estou à espera (" + p.getIdentification() +") da posição " + cell.getPosition() + " ocupada por " + cell.getPlayer().getIdentification());
				cell.busy.await();
			}
			cell.setPlayer(p);
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		} finally {
			cell.lock.unlock();
		}

	}

	public static class CountDownLatch implements Serializable {
		public CountDownLatch(int count) {
			this.count = count;
		}
		private int count;
		public synchronized void await()
				throws InterruptedException {
			while ( count> 0)
				wait();
		}
		public synchronized void countDown(){
			count--;
			if(count == 0)
				notifyAll();
		}

		public int getCount() {
			return count;
		}
	}

	public Cell[][] getBoard(){
		return this.board;
	}
	public void setBoard(Cell[][] board){
		this.board = board;
		notifyChange();
	}


}
