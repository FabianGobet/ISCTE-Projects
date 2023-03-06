package pt.iul.poo.firefight.starterpack;

import java.util.List;

public interface Updatable {
	
	public void update();
	
	public static void updateAll(List<Updatable> updatables) {
		updatables.forEach(u-> u.update());
	}

}
