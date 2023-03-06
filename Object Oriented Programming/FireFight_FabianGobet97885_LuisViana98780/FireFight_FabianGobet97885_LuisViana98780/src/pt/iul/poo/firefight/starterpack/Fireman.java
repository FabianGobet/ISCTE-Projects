package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Point2D;
import pt.iul.ista.poo.utils.Vector2D;

import java.awt.event.KeyEvent;
import java.util.List;

import pt.iul.ista.poo.utils.Direction;

public class Fireman extends GameElement implements Movable,Activatable,Interactable,Updatable{
	
	public boolean active=false;
	private Direction direcao;
	public boolean isNext=false;
	public boolean goingForIt=false;
	
	public Fireman(Point2D ponto) {
		super(ponto);
	}
	
	public Fireman(Point2D ponto, boolean status) {
		super(ponto);
		this.active=status;
	}
	
	@Override
	public String getName() {
		if(active) {
			if(this.direcao!=null) {
				if(this.direcao.equals(Direction.LEFT) || this.direcao.equals(Direction.RIGHT))
					return "fireman_"+direcao.name().toLowerCase();
				else return "fireman";
			}
			return "fireman";
		} else {
			if(this.direcao!=null) {
				if(this.direcao.equals(Direction.LEFT) || this.direcao.equals(Direction.RIGHT))
					return (isNext?  "firemanbot_"+direcao.name().toLowerCase()+"_next":"firemanbot_"+direcao.name().toLowerCase());
				else return (isNext? "firemanbot_next":"firemanbot");
			}
			return (isNext? "firemanbot_next":"firemanbot");
		}
	}

	@Override
	public int getLayer() {
		return 2;
	}
	

	@Override
	public void activate() {
		this.active=true;	
	}

	@Override
	public void deactivate() {
		this.active=false;
		
	}

	@Override
	public void interact() {
		ge.addTile(new Blood(this.position));
		ge.removeTile(this);
		
	}

	@Override
	public boolean isActive() {
		return active;
	}
	
	public void riding(Point2D target) {
		this.position=target;
	}

	public static Fireman firemanOnPosition(Point2D target) {
		return GameEngine.getInstance().getObject(o->(o instanceof Fireman) && o.getPosition().equals(target));
	}
	
	private void conscious(int key) {
		Point2D target = getPosition().plus(Direction.directionFor(key).asVector());
		if(ge.gui.isWithinBounds(target)) { 
			Fire fogo = Fire.getThat(target);
			Driveable b = Driveable.getThat(target);
			this.direcao=Direction.directionFor(ge.gui.keyPressed());
			if (fogo!=null) { 
				ge.addTile(new Water(fogo.getPosition(),this.direcao));
				ge.score.addPoints(10);
			}
			else if(b!=null && !b.isOn()) {
				this.position=target;
				b.activate();
				b.ride(this);
			}
			else this.position=target;
		}
	}
	
	private Vector2D vectorTo(Point2D target) {
		int difX = target.getX()-this.position.getX();
		int difY = target.getY()-this.position.getY();
		if(Math.abs(difX)>Math.abs(difY)) {
			if(difX>0)
				return new Vector2D(1,0);
			else
				return new Vector2D(-1,0);
		} else {
			if(difY>0)
			return new Vector2D(0,1);
		else
			return new Vector2D(0,-1);
		}
	}
	
			
	
	private void unconscious() {
		Point2D p = closestFirePoint(); 
		if(p!=null) {
			Point2D target = getPosition().plus(vectorTo(p));
			Fire fogo = Fire.getThat(target);
			Driveable b = Driveable.getThat(target);
			this.direcao=Direction.forVector(vectorTo(p));
			if (fogo!=null) { 
				ge.addTile(new Water(fogo.getPosition(),this.direcao));
			} else if(b==null){
				this.position=target;
			} else {
				while(!ge.gui.isWithinBounds(target) || Driveable.getThat(target)!=null) {
					target=this.position.plus(Direction.random().asVector());
				}
				this.position=target;
			}
		}
	}
	
	private Point2D closestFirePoint() {
		List<Fire> lista = ge.getAllObjects(o-> o instanceof Fire);
		Point2D p = null;
		lista.sort((a,b)-> a.distanceTo(this.position)-b.distanceTo(this.position));
		if(!lista.isEmpty())
			p=lista.get(0).getPosition();
		return p;
	}
	
	private void nextIsNext(Fireman f) {
		int indexOfNext = ge.lvls.bombeiros.indexOf(f)+1;
		if(indexOfNext>=ge.lvls.bombeiros.size())
			ge.lvls.bombeiros.get(0).isNext=true;
		else 
			ge.lvls.bombeiros.get(indexOfNext).isNext=true;
	}


	public void changePlayer() {
		this.deactivate();
		if(!ge.lvls.fit.hasNext()) 
			ge.lvls.fit = ge.lvls.bombeiros.iterator();
		Fireman jj = ge.lvls.fit.next();
		jj.goingForIt=true;
		nextIsNext(jj);
	}
	
	@Override
	public void move() {
		int key = ge.gui.keyPressed();
		if(Direction.isDirection(key) || key==KeyEvent.VK_L || key==KeyEvent.VK_P || key==KeyEvent.VK_ENTER) 
			if(active) {
				if(key==KeyEvent.VK_L) 
					changePlayer();
				else if(key!=KeyEvent.VK_P && key!=KeyEvent.VK_ENTER)
				conscious(key);
			}
			 else 
				unconscious();
	}

	@Override
	public void update() {
		if(this.goingForIt) {
			this.activate();
			this.isNext=false;
			this.goingForIt=false;
		}
	}
	

}
