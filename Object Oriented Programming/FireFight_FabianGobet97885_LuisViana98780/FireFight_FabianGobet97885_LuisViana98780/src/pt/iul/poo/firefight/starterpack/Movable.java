package pt.iul.poo.firefight.starterpack;

import java.util.List;


public interface Movable {
	
	public void move();
	
	public static void moveAll(List<Movable> movables) {
		movables.forEach(m->m.move());
	}

}
