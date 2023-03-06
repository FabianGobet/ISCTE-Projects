package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Point2D;

public class Land extends GameElement{

	public Land(Point2D ponto) {
		super(ponto);
	}

	@Override
	public String getName() {
		return "land";
	}

	@Override
	public int getLayer() {
		return 0;
	}


}
