class Rectangle {
	
	final int width;
	final int height;
	
	Rectangle(int width, int height){
		this.width = width;
		this.height = height;
	}
	
	
	Rectangle(int side){
		this.width = side;
		this.height = side;
	}
	
	int getArea(){
		return this.width*this.height;
	}
	
	int getPerimeter(){
		return 2*this.width+2*this.height;
	}
	
	
	double getDiagonal(){
		return Math.sqrt((double)(this.width*this.width + this.height*this.height));
	}
	
	boolean isSquare(){
		return this.width == this.height;
	}
	
	
	Rectangle scale(int n){
	if(n<0)
		throw new IllegalArgumentException("Não pode ser negativo.");
	else if(n==1)
		return this;
	else 
		return new Rectangle(this.width*n, this.height*n);
	}
	
	
	Rectangle sum(int width, int height){
		return new Rectangle((this.width+width<0) ? 0 : this.width+width, (this.height+height<0) ? 0 : this.height+height);		
	}
	
	
	boolean isAreaBigger(Rectangle r){
		return this.getArea() > r.getArea();
	}
	
	static Rectangle greatestArea(Rectangle r1, Rectangle r2){
	return (r1.getArea() > r2.getArea()) ? r1 : r2;	
	}
	
	
	
//	static void test(){
//	Rectangle re1 = new Rectangle(1,2);
//	Rectangle re2 = re1.scale(1);
//	}
	
}