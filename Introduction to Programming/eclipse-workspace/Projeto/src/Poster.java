class Poster {
	
	Layer[] layers;
	final int initalSize = 10;
	ColorImage tela;
	int next;
	int x;
	int y;
	
	
	//A tela é uma imagem independente das layers
	// que serve de base relativa para dimensões do poster
	Poster(int x, int y){
		this.layers = new Layer[initalSize];
		this.tela = Image.whiteImage(x,y); 
		this.next = 0;
		this.x = x;
		this.y = y;
	}
	
	int getX() {
		return x;
	}

	int getY() {
		return y;
	}

	// Adiciona uma imagem de fundo como a primeira layer e mete-a ativa por default
	void addBackgroundPattern(ColorImage img){
		if(img==null)
			throw new NullPointerException("Can't use null ColorImage");
		this.layers[0] = new Layer(Image.background(tela, img));
		this.layers[0].setActive(true);
		if(this.next==0)
			this.next=1;
	}
	
	// Aumenta a quantidade possivel da coleção layer de Layer[]
	void copyBigger(Layer[] layers){
		Layer[] nova = new Layer[layers.length+5];
		for(int i=0; i<layers.length; i++)
			nova[i] = layers[i];
		this.layers = nova;
	}
	
	
	// Adiciona uma nova layer no primeiro index nao usado em Layer[] e ativa-a
	// aumenta o tamanho de Layer[] por 5 unidades se necessario, automaticamente
	void add(Layer layer){
		if(layer==null)
			throw new NullPointerException("Can't use null layer");
		if(this.next>=this.layers.length){
			copyBigger(this.layers);
			add(layer);
		}
		else {
			this.layers[next] = layer;
			this.layers[next].setActive(true); 
			this.next++;
		}
	}
	
	// Remove layer do index x e faz shift left às restantes
	void remove(int x){
		if(this.layers[x]==null)
			throw new IllegalStateException("No object in position "+x+".\nNull object.");
		for(int i=x; i<this.next-1; i++)
			this.layers[i] = this.layers[i+1];
		next--;
		this.layers[next]=null;
	}
	
	//insert layer in spot x and shift the rest forward
	void insert(int x, Layer layer){
		if(layer==null)
			throw new NullPointerException("Can't use null layer");
		if(x>=this.layers.length)
			throw new IllegalStateException("Index "+x+" not available.\nPlease use add(layer) procedure instead.");
		for(int i=this.next; i>x; i--)
			this.layers[i] = this.layers[i-1];
		this.layers[x] = layer;
		this.next++;
	}
	
	
	//Troca as layers nos indexs x e y de sitio
	void switchSpot(int x, int y){
		if(layers[x]==null || layers[y]==null)
			throw new IllegalArgumentException("Can't switch spots with null object.");
		Layer old = this.layers[x];
		this.layers[x] = this.layers[y];
		this.layers[y] = old;
	}
	
	// Gera o posta com ordem contraria de prevalencia das layers em Layer[]
	ColorImage finalPoster(){
		ColorImage img = Image.copy(tela);
		for(int i=0; i<next; i++)
			if(layers[i].isActive())
				Image.noWhiteCopy(layers[i].finalImage(), img);
		return img;
	}
	
	
	
////para testar a classe	
	
//	static void test(){
//	ColorImage img1 = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\pattern.png");
//	ColorImage img2 = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\imagem_texto.png");
//	ColorImage img3 = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\donald.png");
//	ColorImage img4 = Image.circularCut(img3.getWidth()/2-14, img3.getHeight()/2-14, 80, img3);
//	System.out.print(img2.getWidth() + " " + img2.getHeight());
//	Poster poster = new Poster(400,300);
//	poster.addBackgroundPattern(img1);
//	Layer layer1 = new Layer(img2,170,100);
//	Layer layer2 = new Layer(img4,60,30);
//	poster.add(layer1);
//	poster.add(layer2);
//	ColorImage fim = poster.finalPoster();
//	Poster poster = new Poster(200,200);
//	ColorImage img1 = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\pattern.png");
//	poster.addBackgroundPattern(img1);
//	ColorImage img2 = new ColorImage("C:/Users/fabia/eclipse-workspace/Semana8/src/colors.png");
//	Layer layer1 = new Layer(img2);
//	poster.add(layer1);
//	layer1.setX(50);
//	layer1.setY(50);
//	ColorImage img3 = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\donald.png");
//	ColorImage img4 = Image.circularCut(img3.getWidth()/2, img3.getHeight()/2, 50, img3);
//	Layer layer2 = new Layer(img4);
//	poster.add(layer2);
//	ColorImage fim = poster.finalPoster();
//	poster.switchSpot(1,2);
//	layer2.setX(60);
//	layer2.setY(60);
//	fim = poster.finalPoster();
//	}
	
	static void discussion(){
		ColorImage a = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\A.jpg");
		ColorImage b = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\B.jpg");
		ColorImage c = new ColorImage("C:\\Users\\fabia\\eclipse-workspace\\Projeto\\src\\C.png");
		Poster poster = new Poster(400,300);
		poster.addBackgroundPattern(a);
		poster.add(new Layer(b));
		poster.add(new Layer(c,200,200));
		poster.layers[1].setScale(1.5);
		poster.layers[1].setName("Imagem B");
		poster.layers[2].setName("Imagem C");
		ColorImage fim = poster.finalPoster();
		
		b = Image.circularCut(50,100,50,b);
		poster.layers[1].setImg(b);
		fim = poster.finalPoster();
		
		poster.layers[1].setActive(false);
		fim = poster.finalPoster();
		
		poster.layers[1].setActive(true);
		poster.layers[1].setX(50);
		poster.layers[1].setY(50);
		fim = poster.finalPoster();
		
		poster.switchSpot(1,2);
		poster.layers[1].setActive(false);
		fim = poster.finalPoster();
		fim = Image.greyPosterize(fim);
		
		System.out.println();
		
	}
	
	
	}	