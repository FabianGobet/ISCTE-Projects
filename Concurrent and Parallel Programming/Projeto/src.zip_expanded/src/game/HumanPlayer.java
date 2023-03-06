package game;

import environment.Cell;
import environment.Coordinate;
import environment.Direction;

public class HumanPlayer extends Player {
    public HumanPlayer(int id, Game game) {
        super(id, game,(byte)5);
    }

    @Override
    public boolean isHumanPlayer() {
        return true;
    }



    @Override
    protected void move(Coordinate coord) {
        Cell nextCell = game.getCell(coord);
        Cell currentCell = getCurrentCell();
        nextCell.lock.lock();
        currentCell.lock.lock();
        try {
            if (nextCell.isOcupied()) {
                Player hostile = nextCell.getPlayer();
                if (!nextCell.getPlayer().isObstacle()) fight(hostile);
            } else {
                nextCell.setPlayer(this);
                currentCell.setPlayer(null);
            }
        } finally {
            currentCell.busy.signal();
            currentCell.lock.unlock();
            nextCell.lock.unlock();
        }
    }
}
