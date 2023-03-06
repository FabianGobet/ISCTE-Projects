class Layer {
	
	ColorImage img;
	String name;
	int x;
	int y;
	double scale;
	boolean active;
	
	Layer(ColorImage img, double scale, int x, int y, String name){
		this.img = img;
		this.name = name;
		this.x = x;
		this.y = y;
		this.scale = scale;
	}
	
	Layer(ColorImage img, int x, int y){
		this.img = img;
		this.x = x;
		this.y = y;
		this.scale = 1;
	}
	
	Layer(ColorImage img){
		this.img = img;
		this.x = 0;
		this.y = 0;
		this.scale = 1;
	}
	
	//Getters e Setters
	
	ColorImage getImg(){
		return this.img;
	}
	
	void setImg(ColorImage img){
		this.img = img;
	}
	
	String getName(){
		return this.name;
	}
	
	void setName(String nome){
		this.name = nome;
	}
	
	double getScale(){
		return this.scale;
	}
	
	void setScale(double scale){  
		this.scale = scale;
	}

	int getX() {
		return x;
	}

	void setX(int x) {
		this.x = x;
	}

	int getY() {
		return y;
	}

	void setY(int y) {
		this.y = y;
	}
	
	boolean isActive(){
		return this.active;
	}
	
	void setActive(boolean is){
		this.active = is;
	}
	
	
	//imagem final preparada para noWhiteCopy no Poster
	// escalada por scale em relação ao tamanho original
	ColorImage finalImage(){
		ColorImage amp = Image.scaled(this.img, scale);
		ColorImage nova = new ColorImage(this.x+amp.getWidth(), this.y+amp.getHeight());
		for(int i=0; i<nova.getWidth(); i++)
			for(int j=0; j<nova.getHeight(); j++)
				if(i<x || j<y)
					nova.setColor(i,j,new Color(255,255,255));
				else
					nova.setColor(i,j,amp.getColor(i-x, j-y));
		return nova;
		
	}
	
	
	
////testar a classe	
	
//	static void test(){
//		ColorImage lol = new ColorImage("C:/Users/fabia/eclipse-workspace/Semana8/src/colors.png");
//		Layer layer = new Layer(lol,1.5, 20,30,"nova");
//		ColorImage fim = layer.finalImage();
//		int a = fim.getWidth();
//		int b = fim.getHeight();
//		ColorImage teste = new ColorImage(92,159);
//		Image.noWhiteCopy(fim,teste);
//	}
	
	
	

}