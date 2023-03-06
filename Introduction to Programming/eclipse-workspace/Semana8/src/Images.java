class Images {
	
	static void posterize(ColorImage img, Color cor1, Color cor2){
		for(int i=0; i<img.getWidth(); i++)
			for(int j=0; j<img.getHeight(); j++)
				if(img.getColor(i,j).getLuminance()<128)
					img.setColor(i,j, cor1);
				else 
					img.setColor(i,j,cor2);
	}
	
	static ColorImage popArt(ColorImage img){
		ColorImage nova = new ColorImage(2*img.getWidth(), 2*img.getHeight());
		nova.paste(0,0,img.posterize(Color.DARKBLUE, Color.LIGHTBLUE));
		nova.paste(0,img.getHeight(),img.posterize(Color.DARKRED, Color.LIGHTRED));
		ColorImage copia = img.copy();
		copia.mirror();
		nova.paste(img.getWidth(),0,copia.posterize(Color.DARKGREEN, Color.LIGHTGREEN));
		nova.paste(img.getWidth(),img.getHeight(),copia.posterize(Color.DARKPURPLE, Color.LIGHTPURPLE));
		return nova;
	}
	
	static ColorImage[] image4split(ColorImage img){
		ColorImage[] vector = new ColorImage[4];
		vector[0] = img.selection(0,0,img.getWidth()/2, img.getHeight()/2);
		vector[2] = img.selection(img.getWidth()/2+1,0,img.getWidth()-1, img.getHeight()/2);
		vector[1] = img.selection(0,img.getHeight()/2+1,img.getWidth()/2, img.getHeight()-1);
		vector[3] = img.selection(img.getWidth()/2+1,img.getHeight()/2+1,img.getWidth()-1, img.getHeight()-1);
		return vector;
	}
	
	
	static ColorImage horizontalMerge(ColorImage left, ColorImage right){
		ColorImage nova = new ColorImage(left.getWidth()+right.getWidth(), Math.max(left.getHeight(), right.getHeight())); //Colorimage(colunas, linhas)
		nova.paste(0,0,left);
		nova.paste(left.getWidth(),0, right);
		return nova;
	}
	
	
	static void test(){
		int b=0;
		ColorImage imagem = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Semana8\\src\\loveyou.jpg");
		Color branco = new Color(255,255,255);
		Color preto = new Color(0,0,0);
		posterize(imagem, branco, preto);
//		ColorImage[] vetor = image4split(imagem);
//		ColorImage nova = horizontalMerge(vetor[0], vetor[2]);
//		ColorImage imagem2 = popArt(imagem);	
	}
								
					
}
