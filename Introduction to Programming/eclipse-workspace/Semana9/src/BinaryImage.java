class BinaryImage {
	
	private boolean[][] data; // @binaryimage
	
	/**
	 * Creates a binary image from the given image file (GIF, JPG, PNG).
	 * The pixels of the original image will be converted to
	 * black/white according to their luminance value.
	 */
	BinaryImage(String path) {
		this.data = ImageUtil.readBinaryImage(path);
	}
	
	/**
	 * Creates a black binary image with the given dimension in pixels.
	 */
	BinaryImage(int width, int height) {
		data = new boolean[height][width];
	}
	
	BinaryImage(Rectangle r){
	this.data = new boolean[r.width][r.height];	
	}
	
	Rectangle sizeInRectangle(){
		return new Rectangle(this.getWidth(), this.getHeight());
	}
	
	boolean isPointWhite(Point point){
		return !isBlack(point.x, point.y);
	}
	
	
	void paint(Point point, boolean white){
		if(white)
			this.setWhite(point.x, point.y);
		else
			this.setBlack(point.x, point.y);
	}
	
	int getCount(boolean white){
		int count=0;
			for(int i=0; i<this.getWidth(); i++)
				for(int j=0; j<this.getHeight(); j++)
					if(white ^ isBlack(i,j)) //(white && !isBlack(i,j)) || (!white && isBlack(i,j), ^ stands for XOR
							count++;
					return count;
	}
	
	void invertColor(){
		for(int i=0; i<this.getWidth(); i++)
			for(int j=0; j<this.getHeight(); j++)
				if(isBlack(i,j))
					this.setWhite(i,j);
				else
					this.setBlack(i,j);
	}
	
	
	void fillRectangle(Point point, Rectangle r){
		if(point.x + r.width > this.getWidth() || point.y + r.height > this.getHeight())
			throw new IllegalStateException("Out of frame.");
		for(int i=point.x; i<= point.x + r.width; i++)
			for(int j=point.y; j<= point.y + r.height; j++)
				this.setWhite(i,j);
	}
	
	void whiteBorder(){
		for(int i=0; i<this.getWidth(); i++){
			this.setWhite(i,0);
			this.setWhite(i,this.getHeight()-1);
		}
		for(int i=2; i<this.getHeight()-1; i++){
			this.setWhite(0,i);
			this.setWhite(this.getWidth()-1,i);
		}
	}
		
				
	

	/**
	 * Image width in pixels,
	 */
	int getWidth() {
		return data[0].length;
	}
	
	/**
	 * Image height in pixels,
	 */
	int getHeight() {
		return data.length;
	}
	
	/**
	 * Is pixel at (x, y) black?
	 */
	boolean isBlack(int x, int y) {
		validatePosition(x, y);
		return !data[y][x];
	}
	
	/**
	 * Sets the pixel at (x, y) to white.
	 */
	void setWhite(int x, int y) {
		validatePosition(x, y);
		data[y][x] = true;
	}
	
	/**
	 * Sets the pixel at (x, y) to black.
	 */
	void setBlack(int x, int y) {
		validatePosition(x, y);
		data[y][x] = false;
	}
	
	/**
	 * Is (x, y) a valid pixel position in this image?
	 */
	boolean validPosition(int x, int y) {
		return 
			x >= 0 && x < getWidth() &&
			y >= 0 && y < getHeight();
	}
	
	void validatePosition(int x, int y) {
		if(!validPosition(x, y))
			throw new IllegalArgumentException(
					"invalid point " + x + ", " + y + 
					": matrix dimension is " + getWidth() + " x " + getHeight());
	}
	
	
}