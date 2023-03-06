
class ColorImage {

	private int[][] data; // @colorimage

	ColorImage(String file) {
		this.data = ImageUtil.readColorImage(file);
	}

	ColorImage(int width, int height) {
		data = new int[height][width];
	}

	int getWidth() {
		return this.data[0].length;
	}

	int getHeight() {
		return this.data.length;
	}

	void setColor(int x, int y, Color c) {
		data[y][x] = ImageUtil.encodeRgb(c.getR(), c.getG(), c.getB());
	}

	Color getColor(int x, int y) {
		int[] rgb = ImageUtil.decodeRgb(data[y][x]);
		return new Color(rgb[0], rgb[1], rgb[2]);
	}
	
	
	void inverseColor(){
		for(int i=0; i<getWidth(); i++)
			for(int j=0; j<getHeight(); j++)
				setColor(i, j, getColor(i,j).inverse());	
	}
	
	
	void brighterColor(int value){
		for(int i=0; i<getWidth(); i++)
			for(int j=0; j<getHeight(); j++)
				setColor(i, j, getColor(i,j).brighter(value));
	}
	
	void mirror(){
		for(int i=0; i<getWidth()/2; i++)
			for(int j=0; j<getHeight(); j++){
				Color cor = getColor(getWidth()-i-1,j);
				setColor(getWidth()-i-1,j, getColor(i,j));
				setColor(i,j,cor);
			}
	}
	
	
	void paste(int x, int y, ColorImage img){
		if(x+img.getWidth() > getWidth())
			throw new IllegalStateException("Image doesn't fit in the frame in width.");
		else if(y+img.getHeight() > getHeight())
			throw new IllegalStateException("Image doesn't fit in the frame in height.");
		for(int i=0; i<img.getWidth(); i++)
			for(int j=0; j<img.getHeight(); j++)
				setColor(x+i,y+j,img.getColor(i,j));
	}
	
	
	
	ColorImage posterize(Color dark, Color light){ //posterize com cores definidas
		ColorImage nova = new ColorImage(getWidth(),getHeight());
		for(int i=0; i<getWidth(); i++)
			for(int j=0; j<getHeight(); j++)
				if(getColor(i,j).getLuminance()<128)
					nova.setColor(i,j, dark);
				else 
					nova.setColor(i,j, light);
		return nova;
		}
	
	
	ColorImage posterize(){ //preto e branco
		return posterize(new Color(0,0,0), new Color(255,255,255));
		}
	
	ColorImage copy(){
		ColorImage nova = new ColorImage(getWidth(),getHeight());
		for(int i=0; i<getWidth(); i++)
			for(int j=0; j<getHeight(); j++)
				nova.setColor(i,j,getColor(i,j));
		return nova;
	}
	
	ColorImage selection(int startx, int starty, int endx, int endy) {
		ColorImage nova = new ColorImage(endx-startx+1, endy-starty+1);
		for(int i=0; i<endx-startx+1; i++)
			for(int j=0; j<endy-starty+1; j++)
				nova.setColor(i,j,getColor(startx+i, starty+j));
		return nova;
	}
	
	
	
	
}