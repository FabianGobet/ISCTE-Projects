class semana2 {
	
	static int max(int a, int b){
		if(a>b){
			return a;
		}
		return b;
	}
	
	static boolean isMultiple(int a, int b){
		if(a>b){
			return (a/b)*b==a;
		} else{
			return (b/a)*a==b;
		}
	}
	
	static int abs(int a){
		if(a<0){
			return -1*a;
		}
		return a;
	}
	
	
	static int divide(int a, int b){
		int quociente = 0;
		while(a>=b){
			a=a-b;
			quociente = quociente +1;
		}
		return quociente;
	}
	
	static int powerOfTwo(int n){
		int a = 1;
		while(n>0){
			a=a*2;
			n=n-1;
		}
		return a;
	}
	
	
	static int sumOfNaturalsUpTo(int n){
		int soma = 0;
		while(n>0){
			soma=soma+n;
			n=n-1;
		}
		return soma;
	}
	
	
	static int sumOfEvenNumbersBetween(int a, int b){
		if(a%2!=0){
			a+=1;
		}
		int soma=0;
		while(a<=b){
			soma+=a;
			a+=2;
		}
		return soma;
	}
	
	
	static int firstDigit(int a){
		while(a>9 || a<-9){
			a=a/10;
		}
		return a;
	}
	
	static int fibonacci(int n){
		int termo = 1;
		int anterior = 0;
		while(n>1){
			int save = termo;
			termo += anterior;
			anterior = save;
			n=n-1;
		}
		return termo;
	}
	
			
	static int gcd(int a, int b){
		if(a<b){
			int c = b;
			b=a;
			a=c;
		}
		while(b!=0){
			int r=a%b;
			a=b;
			b=r;
		}
		return a;
	}
	
	static int func(int a){
		boolean b = 5;
		int n = 9;
		int m = n + 1;
		double d = m + 1;
		int x = b + 1;
		return n;
		}
			
			

}