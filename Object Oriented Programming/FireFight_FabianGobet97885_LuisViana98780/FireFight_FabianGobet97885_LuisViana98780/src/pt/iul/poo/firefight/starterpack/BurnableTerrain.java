package pt.iul.poo.firefight.starterpack;

import pt.iul.ista.poo.utils.Point2D;

public abstract class BurnableTerrain extends GameElement implements Updatable{
	
	public boolean isOnFire = false;
	public int count = 0;
	public int limit;
	public boolean isBurned = false;
	
	public BurnableTerrain(Point2D p, int limit) {
		super(p);
		this.limit = limit;
	}
	
	public void increment() {
		if(isOnFire) {
			this.count++;
		}	
	}

	public void resetCount() {
		this.count=0;
	}
	
	public void burnt() {
		if(count == limit && isOnFire) {
			isBurned = true;
			ge.removeTile(Fire.getThat(this.position));
			isOnFire=false;
			ge.score.addPoints(-2);
		}
	}
	

		
	public abstract boolean ignition();
	
	@Override
	public void update() {
		if(isOnFire==false && Fire.getThat(this.position)!=null)
			isOnFire=true;
		increment();
		burnt();
	}
	
	public static BurnableTerrain getThat(Point2D target) {
		BurnableTerrain element = GameEngine.getInstance().getObject(o->(o instanceof BurnableTerrain) && o.getPosition().equals(target));
		return element;
	}
	
	@Override
	public int getLayer() {
		return 1;
	}
	
}
