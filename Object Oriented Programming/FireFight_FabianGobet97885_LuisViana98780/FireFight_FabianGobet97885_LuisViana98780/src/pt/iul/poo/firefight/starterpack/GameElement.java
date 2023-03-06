package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.gui.ImageMatrixGUI;
import pt.iul.ista.poo.gui.ImageTile;
import pt.iul.ista.poo.utils.Point2D;

public abstract class GameElement implements ImageTile{
	
	public GameEngine ge = GameEngine.getInstance();
	public Point2D position;
	public ImageMatrixGUI gui = ImageMatrixGUI.getInstance();

	public GameElement(Point2D ponto) {
		this.position = ponto;
	}
	
	
	@Override
	public Point2D getPosition() {
		return position;
	}
	
	
	

}
