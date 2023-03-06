package pt.iul.poo.firefight.starterpack;

import java.awt.event.KeyEvent;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;
import pt.iul.ista.poo.gui.ImageMatrixGUI;
import pt.iul.ista.poo.gui.ImageTile;
import pt.iul.ista.poo.observer.Observed;
import pt.iul.ista.poo.observer.Observer;
import pt.iul.ista.poo.utils.Direction;


public class GameEngine implements Observer{
	
	public ImageMatrixGUI gui;
	public List<ImageTile> tileList;
	private static GameEngine INSTANCE;
	public Level lvls;
	public Score score;
	
	
		
	private GameEngine() {
		gui = ImageMatrixGUI.getInstance();    
		gui.registerObserver(this);           
		tileList = new ArrayList<>(); 
	}
	
	public static GameEngine getInstance() {
	        if (INSTANCE == null)
	            INSTANCE = new GameEngine();
	        return INSTANCE;
	    }
	
	
	@Override
	public void update(Observed source) {
		int key = gui.keyPressed();
		if(isValidKey(key)) {
			if((key==KeyEvent.VK_L && lvls.bombeiros.size()>1) || !(key==KeyEvent.VK_L))
				moveAll();
				Fire.spreadFire();
				updateAll();
				if(key==KeyEvent.VK_P) {
					Plane.invoquePlane();
				}
		}
		score.updateMessage();
		gui.update();
		if(!Fire.AreThereFires()) 
			lvls.changeLevel();
	}
	
	private void updateAll() {
		List<Updatable> lista2 = getAllObjects(o-> o instanceof Updatable);
		lista2.forEach(o->o.update());
	}
	
	private void moveAll() {
		List<Movable> lista1 = getAllObjects(o-> o instanceof Movable);
		lista1.forEach(o->o.move());
	}
	
	private boolean isValidKey(int key) {
		return Direction.isDirection(key) || key == KeyEvent.VK_ENTER || key==KeyEvent.VK_P || key==KeyEvent.VK_L;
	}
	
	public <T> List<T> getAllObjects(Predicate<GameElement> pred) {
		List<T> lista = new ArrayList<>();
		for(ImageTile img : tileList)
			if(pred.test((GameElement)img))
				lista.add((T)img);
			return lista;
	}
	
	public <T> T getObject(Predicate<GameElement> pred){
		for(ImageTile img : tileList)
			if(pred.test((GameElement)img))
				return (T)img;
			return null;
	}
	
	
	public void addTile(ImageTile img) {
		gui.addImage(img);
		tileList.add(img);
	}
	
	public void addTile(List<ImageTile> list) {
		gui.addImages(list);
		tileList.addAll(list);
	}
	
	public void removeTile(ImageTile img) {
		gui.removeImage(img);
		tileList.remove(img);
	}
	
	public void removeTile(List<ImageTile> list) {
		gui.removeImages(list);	
		tileList.removeAll(list);
	}

	
	public void start() {
		lvls = new Level();
		gui.go();
		lvls.changeLevel();
		score = new Score();
		gui.update();
		
	}
}
