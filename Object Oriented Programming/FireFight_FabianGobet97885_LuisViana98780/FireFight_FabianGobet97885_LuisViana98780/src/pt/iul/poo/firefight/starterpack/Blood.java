package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Direction;
import pt.iul.ista.poo.utils.Point2D;

public class Blood extends GameElement{
	
	public Direction direcao=null;
	

	public Blood(Point2D ponto) {
		super(ponto);
	}
	
	public Blood(Point2D ponto, Direction direcao) {
		super(ponto);
		this.direcao=direcao;
	}
	
	
	@Override
	public String getName() {
		String result="blood";
		if(direcao==null) return result;
		else if(direcao.equals(Direction.UP) || direcao.equals(Direction.DOWN))
				result+="_vertical";
		else if(direcao.equals(Direction.LEFT) || direcao.equals(Direction.RIGHT))
			result+="_horizontal";
		return result;
	
	}

	@Override
	public int getLayer() {
		
		return 0;
	}
	
	

}
