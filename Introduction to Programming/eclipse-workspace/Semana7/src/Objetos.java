class Objetos {
	
	static Color randomColor(){
		int r = (int)(Math.random()*256);
		int g = (int)(Math.random()*256);
		int b = (int)(Math.random()*256);
		Color cor = new Color(r,g,b);
		return cor;
	}

	  static Color[] randomColorArray(int length) {
		  Color[] cores = new Color[length];
		  for(int i=0; i<length; i++)
			  cores[i] = randomColor();
		  return cores;
	  }
	  
	  static Color inverted(Color color) {
		  Color cor = new Color(255-color.getR(), 255-color.getG(), 255-color.getB());
		  return cor;
	  }
	  
	  
	  static Color changeBrightness (Color color, int factor) {
		  int r = color.getR();
		  int g = color.getG();
		  int b = color.getB();
		  return new Color(r+factor, g+factor, b+factor);
	  }
	  
	  
	  static BinaryImage randomSizedImg(int length, int height){
		  BinaryImage img = new BinaryImage(length, height);
		  for(int i=0; i<length; i++)
			  for(int j=0; j<height; j++)
				  if(Math.random() < 0.5)
					  img.setWhite(i,j);
		  return img;
	  }
	  
	  static void paintSquare(BinaryImage img, int x, int y, int side){
		  for(int i=x; i<x+side; i++)
			  for(int j=y; j<y+side; j++)
				  img.setWhite(i,j);
	  }
	  
	  static void paintPortrait(BinaryImage img){
		  for(int i=0; i<img.getWidth(); i++){
			  img.setBlack(i,img.getHeight()-1);
			  img.setBlack(i,0);
		  }
		  for(int j=1; j<img.getHeight()-1; j++){
			  img.setBlack(0,j);
			  img.setBlack(img.getWidth()-1,j);
		  }
	  }
	  
	  
	  static BinaryImage createChessBoard(int size){
		  BinaryImage img = new BinaryImage(8*size+2,8*size+2);
		  for(int i=1; i<9; i++)
			  if(i%2!=0){ 
				  for(int j=1; j<img.getWidth()-1; j+=2*size)
					  paintSquare(img,j,(i-1)*size+1,size);
			  } else{ 
				  for(int j=1+size; j<img.getWidth()-1; j+=2*size)
					  paintSquare(img,j,(i-1)*size+1,size);
			  }
		  return img;
	  }
	  
	  static void reverse(BinaryImage img){
		  for(int i=0; i<img.getWidth(); i++)
			  for(int j=0; j<img.getHeight(); j++)
				  if(img.isBlack(i,j))
					  img.setWhite(i,j);
				  else
					  img.setBlack(i,j);		  
	  }
	  
	  static BinaryImage newReverse(BinaryImage img){
		  BinaryImage nova = new BinaryImage(img.getWidth(), img.getHeight());
		  for(int i=0; i<img.getWidth(); i++)
			  for(int j=0; j<img.getHeight(); j++)
				  if(img.isBlack(i,j))
					  nova.setWhite(i,j);
				  else
					  nova.setBlack(i,j);
		  return nova;
	  }
	  
	  static BinaryImage scale(BinaryImage img, int scale){
		  BinaryImage nova = new BinaryImage(img.getWidth()*scale, img.getHeight()*scale);
		  for(int i=0; i<nova.getWidth(); i++)
			  for(int j=0; j<nova.getHeight(); j++){
				  if(img.isBlack(i/scale, j/scale))
					  nova.setBlack(i,j);
				  else
					  nova.setWhite(i,j);
			  }
		  return nova;
	  }
	  
	  
	  static BinaryImage merge(BinaryImage img1, BinaryImage img2){
		  BinaryImage nova = scale(img2,1);
		  for(int i=0; i<img1.getWidth(); i++)
			  for(int j=0; j<img1.getHeight(); j++){
				  if(img1.isBlack(i,j) || img2.isBlack(i,j))
					  nova.setBlack(i,j);
				  else
					  nova.setWhite(i,j);
			  }
		  return nova;
	  }
	  
	  
	  static void circle(BinaryImage img, int xcentro, int ycentro, int raio){
		  for(int i=xcentro-raio; i<=xcentro+raio; i++)
			  for(int j=ycentro-raio; j<=ycentro+raio; j++)
				  if((i-xcentro)*(i-xcentro) + (j-ycentro)*(j-ycentro)<= raio*raio)
					  if(Math.random() < 0.5)
						  img.setWhite(i,j);
					  else 
						  img.setBlack(i,j);
	  }
		  

	  
	  static void test(){
		 BinaryImage img = createChessBoard(20);
		 reverse(img);
		 BinaryImage nova = newReverse(img);
		 BinaryImage nova2 = scale(nova, 2);
		 BinaryImage nova3 = merge(nova,nova2);
		// BinaryImage img = new BinaryImage(300, 300);
		// circle(img, 149, 149, 50);
		  int a=0;
	  }
}