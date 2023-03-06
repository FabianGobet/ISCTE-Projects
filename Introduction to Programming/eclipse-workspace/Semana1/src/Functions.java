class Functions {
	
	
	//A
	static int square(int x){ 	
		int a= x*x;
		return a;
	}
	
	
	//B
	static int dif(int x, int y){
		return x-y;
	}
	
	
	//C
	static double reason(int n, int total){
		return (double)(n)/total;
	}
	
	
	//D
	static double media(int x, int y){
		return ((double)(x+y))/2;
	}
	
	//E
	static int round(double x){
		int a = (int)(x);
		if(x-a>=0.5){
			return a+1;
		}
		return a;
	}
	
	
	//F
	static boolean isNegative(int a){
		return a<0;
	}
	
	//G
	static boolean isOdd(int a){
		return a%2!=0;
	}
	
	//H
	static boolean isEven(int a){
		return !isOdd(a);
	}
	
	//I
	static boolean isMultiple(int a, int b){
		if(a%b==0){
			return true;
		} else if(b%a==0){
			return true;
		}
		return false;
	}
	
	
	//J
	static boolean isSingle(int a){
		return a>-1 && a<10;
	}
	
	
	//K
	static boolean isInRange(int a, int b, int c){
		return a>=b && a<=c;
	}
	
	//L
	static boolean isExcluded(int a, int b, int c){
		return !isInRange(a,b,c);
	}
	
	//M
	static boolean xor(boolean a, boolean b){
		return (a && !b) || (!a && b);
	}
	
	static boolean isVowel(char ch){
		return (ch=='a' || ch=='e' ||ch=='i' ||ch=='o' ||ch=='u');
	}
	
	
	static int produto(int a, int b){
		int resultado = 0;
		int somasPorFazer = b;
		while(somasPorFazer !=0){
			resultado = resultado + 1;
			somasPorFazer = somasPorFazer - 1;
		}
		return resultado;
	}

	
}