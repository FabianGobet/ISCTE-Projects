class Image {
	
	// Para ver se as cores são iguais
	static boolean isEqualTo(Color cor1, Color cor2){
		return cor1.getR()==cor2.getR() && cor1.getG()==cor2.getG() && cor1.getB()==cor2.getB();
	}
		
		
	// Copia a parte não transparente(não branca) de imgcopy para imgpaste
	// Copia para pixels x,y de imgpaste e permite cortes da imgcopy nos limites de imgpaste
	// Manda exceptions caso alguma das coordenadas x,y esteja completamente fora dos limites de imgpaste.
	static void noWhiteCopy(ColorImage imgcopy, ColorImage imgpaste, int x, int y){
			if(imgcopy==null || imgpaste==null)
				throw new NullPointerException("Can't use null ColorImage's.");
			if(x>=imgpaste.getWidth() || y>=imgpaste.getHeight())
				throw new IllegalArgumentException("Coordinates are out of frame for given image to paste to");
			for(int i=0; i<imgcopy.getWidth() && i+x<imgpaste.getWidth(); i++)
				for(int j=0; j<imgcopy.getHeight() && j+y<imgpaste.getHeight(); j++)
					if(!isEqualTo(imgcopy.getColor(i,j), new Color(255,255,255)))
							imgpaste.setColor(x+i,y+j,imgcopy.getColor(i,j));					
	}
	
	// Copia parte não transparente de imcopy para imgpaste, a prtir dos pixeis x,y
	static void noWhiteCopy(ColorImage imgcopy, ColorImage imgpaste){
			noWhiteCopy(imgcopy, imgpaste, 0, 0);
		}
		
		
	// Cria uma imagem com o padrao de img, largura x e altura y
	static ColorImage background(int x, int y, ColorImage img){
		if(img==null)
			throw new NullPointerException("Can't use null ColorImage.");
			ColorImage nova = new ColorImage(x,y);
			for(int i=0; i<x; i++)
				for(int j=0; j<y; j++){
					nova.setColor(i, j, img.getColor(i%img.getWidth(),j%img.getHeight()));
				}
			return nova;
		}
		
	// Dado um fundo, cria imagem com padrao img do tamanho deste fundo
	static ColorImage background(ColorImage fundo, ColorImage img){
			return background(fundo.getWidth(), fundo.getHeight(), img);
		}
	
	// Cria imagem em branco
	static ColorImage whiteImage(int x, int y){
		ColorImage nova = new ColorImage(x,y);
		for(int i=0; i<x; i++)
			for(int j=0; j<y; j++)
				nova.setColor(i,j, new Color(255,255,255));
		return nova;
	}
		
	//amplify or deamplify image by factor	
	static ColorImage scaled(ColorImage img, double factor){
		ColorImage nova = new ColorImage((int)(factor*img.getWidth()), (int)(factor*img.getHeight()));
		for(int i=0; i<nova.getWidth(); i++)
			for(int j=0; j<nova.getHeight(); j++)
				nova.setColor(i,j, img.getColor((int)(i/factor),(int)(j/factor)));
		return nova;
	}
	
	// corte circularde raio raio, de centro xcentro,ycentro, e fundo branco
	static ColorImage circularCut(int xcentro, int ycentro, int raio, ColorImage img){
		if(xcentro-raio<0 || ycentro-raio<0 || xcentro+raio+1>img.getWidth() || ycentro+raio+1>img.getHeight())
			throw new IllegalArgumentException("Circle size out of frame for given centre coordinates.");
		ColorImage nova = new ColorImage(2*raio+1, 2*raio+1);
		for(int i=0;i<2*raio+1; i++)
			for(int j=0; j<2*raio+1; j++)
				if((raio-i)*(raio-i) + (raio-j)*(raio-j) <= raio*raio)
					nova.setColor(i,j,img.getColor(xcentro-raio+i, ycentro-raio+j));
				else
					nova.setColor(i,j, new Color(255,255,255));
		return nova;
		}
	
	
	// Cria uma imagem cópia
	static ColorImage copy(ColorImage img){
		ColorImage nova = new ColorImage(img.getWidth(), img.getHeight());
		for(int i=0; i<img.getWidth(); i++)
			for(int j=0; j<img.getHeight(); j++)
				nova.setColor(i,j,img.getColor(i,j));
		return nova;
	}
	
	
	// Cria uma imagem em tons de cinza da imagem em argumento.
	static ColorImage greyPosterize(ColorImage img){
		ColorImage nova = copy(img);
		for(int i=0; i<img.getWidth(); i++)
			for(int j=0; j<img.getHeight(); j++){
				int cor = (int)(img.getColor(i,j).getR()*0.3+img.getColor(i,j).getG()*0.59+img.getColor(i,j).getB()*0.11);
				nova.setColor(i,j, new Color(cor,cor,cor));
			}
		return nova;
	}
	
////para testar a classe	
	
	
//	static void test(){
//		Color cor3 = null;
//		Color cor4 = null;
//		boolean is = cor3==cor4;
//		Color cor1 = new Color(3,2,1);	
//		Color cor2 = new Color(4,2,1);	
//		boolean isit = isEqualTo(cor1,cor2);
//		ColorImage img1 = new ColorImage(10,10);
//		ColorImage img2 = new ColorImage(20,20);
//		for(int i=6; i<19; i++)
//			for(int j=6; j<19; j++)
//				img2.setColor(i,j, new Color(255,255,255));
//		noWhiteCopy(img1, img2, 19,17);
//		ColorImage img3 = new ColorImage(10,10);
//		ColorImage img4 = new ColorImage(10,9);
//		noWhiteCopy(img3, img4);
//		ColorImage img5 = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\pattern.png");
//		ColorImage img6 = background(289,267,img5);
//		ColorImage img7 = new ColorImage(289,267);
//		noWhiteCopy(img6,img7);
//		ColorImage img8 = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\pattern.png");
//		ColorImage img9 = scaled(img8, 4);
//		int a = img9.getWidth();
//		int b = img9.getHeight();
//		ColorImage img10 = circularCut(a/2,b/2,(Math.min(a,b)/2)-1,img9);
//		ColorImage img11 = greyPosterize(img9);
//	}
	


}