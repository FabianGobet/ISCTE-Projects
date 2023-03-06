import java.util.Scanner;

class Vocabulary {
	
	String[][] book;
	Scanner scanner = new Scanner(System.in);
	int current;
	
	Vocabulary(int n){
		if(n<0)
			throw new IllegalArgumentException("Não se pode usar numeros negativos.");
		this.book = new String[n][2];
		this.current = 0;
	}
	
	
	void extend(){
		String[][] newbook = new String[book.length+100][2];
		for(int i=0; i<book.length; i++)
			for(int j=0; j<2; j++)
				newbook[i][j] = book[i][j];
		this.book = newbook;
	}
	
	
	void add(String word, String meaning){
		this.book[current][0] = word;
		this.book[current][1] = meaning;
		this.current++;
	}
	
	

}