package pt.iul.poo.firefight.starterpack;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import pt.iul.ista.poo.gui.ImageTile;
import pt.iul.ista.poo.utils.Point2D;

public class Level implements Iterator<File>{
	

	private static int GRID_HEIGHT = 10;
	private static int GRID_WIDTH = 10;
	private List<File> lvls = levels();
	private Iterator<File> it = lvls.iterator();
	private GameEngine ge = GameEngine.getInstance();
	private String fileName;
	public List<Fireman> bombeiros;
	public Iterator<Fireman> fit;
	
	
	
	private List<File> levels() {
		List<File> levelFiles = new ArrayList<>();
		File[] files = new File("./levels").listFiles();
		
		
		for(File f : files)
			if(!f.getName().contains("_pontos"))
				levelFiles.add(f);
		return levelFiles;	
	}
	
	public static int getWidth() {
		return GRID_WIDTH;
	}

	@Override
	public boolean hasNext() {
		return it.hasNext();
	}

	@Override
	public File next() {
		return it.next();
	}
	
	
	private GameElement getMapElement(char c, int x, int y) {
		GameElement elemento = null;
		Point2D ponto = new Point2D(x,y);
		switch(c) {
		case 'p':
			elemento = new Pine(ponto);
			break;
		case 'e':
			elemento = new Eucaliptus(ponto);
			break;
		case 'm':
			elemento = new Grass(ponto);
			break;
		case 'b':
			elemento = new FuelBarrel(ponto);
			break;
		case 'a':
			elemento = new Abies(ponto);
			break;
		case '_':
			elemento = new Land(ponto);
			break;
		default:	
		}
		return elemento;
	}
	
	private GameElement getDynamicElement(String name, int x, int y) {
		GameElement elemento = null;
		Point2D ponto = new Point2D(x,y);
		switch(name) {
		case "Fireman":
			elemento = new Fireman(ponto,true); 
			break;
		case "FiremanBot":
			elemento = new Fireman(ponto); 
			break;
		case "Fire":
			elemento = new Fire(ponto);
			break;
		case "Bulldozer":
			elemento = new Bulldozer(ponto);
			break;
		case "FireTruck":
			elemento = new Firetruck(ponto);
			break;
		default:
		}
		return elemento;
	}
	
	
	
	private void loadElements(File file){
		try {
			List<ImageTile> lista = new ArrayList<>();
			Scanner sc = new Scanner(file);
			int i = 0;
			while(sc.hasNext()) {
				String tempRow = sc.nextLine();
				if(!tempRow.contains(" ")) {
					i++;
					GRID_WIDTH=tempRow.length();
					for(int j=0; j<tempRow.length(); j++) {
						lista.add(getMapElement(tempRow.charAt(j), j, i-1));
					}
				} else {
					String[] data = tempRow.split(" ");
					lista.add(getDynamicElement(data[0],Integer.parseInt(data[1]), Integer.parseInt(data[2])));
				}
			}
			GRID_HEIGHT=i;
			ge.gui.setSize(GRID_HEIGHT, GRID_WIDTH); 
			ge.addTile(lista);
			sc.close();
		}
		catch (FileNotFoundException e) {
			System.err.println("Ficheiro não encontrado.");
		}
	}
	
	public String currentFileName() {
		return fileName;
	}
	
	private Fireman getActive() {
		Fireman ff = null;
		for(Fireman f : bombeiros)
			if(f.active) 
				ff=f;
		bombeiros.remove(ff);
		return ff;
	}
	
	
	public void changeLevel() {
		if(!ge.tileList.isEmpty()) {
			ge.score.savePoints();
			ge.removeTile(ge.tileList);
		}
		if(it.hasNext()) {
			File f = it.next();
			fileName=f.getName();
			loadElements(f);
			bombeiros=ge.getAllObjects(o-> o instanceof Fireman);
			if(bombeiros.size()>1) {
				bombeiros.add(0, getActive());
				bombeiros.get(1).isNext=true;
			}
			fit= bombeiros.iterator();
			fit.next();
		} else {
				EndGameScreen finish = new EndGameScreen(this);
				it = lvls.iterator();
				finish.endGame();

		}
	}
}
