class vetoresfor {
	
	static char[] charVector(char c, int n){
		char[] a = new char[n];
		for(int i = 0; i<a.length; i++){
			a[i] = c;
		}
		return a;
	}
	
	static void fill(char a, char[] v){
		for(int i = 0; i<v.length; i++){
			v[i]=a;
		}
	}
	
	
	static void replace(char antigo, char novo, char[] v){
		for(int i=0; i<v.length; i++){
			if(v[i]==antigo){
				v[i] = novo;
			}
		}
	}
	

		
	static char[] sequence(char primeiro, int n){
		char[] v = new char[n];
		for(int i=0;i<n;i++){
			v[i] = (char)((int)primeiro + i);
		}
		return v;
	}

	
	static void changeFirstOcurrence(char antigo, char novo, char[] v){
		boolean nostop = true;
		for(int i = 0; i<v.length && nostop; i++){
			if(v[i]==antigo){
				v[i]=novo;
				nostop = false;
			}
		}
	}
	
	static void changeLastOcurrence(char antigo, char novo, char[] v){
		int controlo=-1;
		for(int i = 0; i<v.length; i++){
			if(v[i]==antigo){
				controlo=i;
			}
		}
		if(controlo!=-1){
			v[controlo] = novo;
		}
	}
	
	static void shiftLeft(char[] v){
		char hold1 = v[0];
		char hold2 = v[v.length-1];
		for(int i = v.length-2; i>=0 ; i--){
			hold1 = v[i];
			v[i] = hold2;
			hold2 = hold1;
		}
		v[v.length-1] = hold1;
	}
		
	
	static void shiftRight(char[] v){
		char hold1;
		char hold2 = v[v.length-1];
		for(int i = 0; i<v.length-1 ; i++){
			hold1 = v[i];
			v[i] = hold2;
			hold2 = hold1;
		}
		v[v.length-1] = hold2;
	}
	
	
	static void swap(int i, int j, char[] v) {
		char hold = v[j];
		v[j]=v[i];
		v[i] = hold;
	}
	
	
	
	static void invert(char[] v){
		for(int i=0; i<v.length/2; i++){
			swap(i,v.length-1-i,v);
		}
	}
	
	
	static int randomIndex(int n){
		return (int)(Math.random()*(n+1));
	}
	
	
	static void fisherYates(char[] v){
		for(int i=0; i<v.length-1; i++){
			swap(i,randomIndex(v.length-1-i)+i,v);
		}
	}
	
	static char[] bubbleSort(char[] v){
		char a;
		for(int i=0; i<v.length-1;i++){
			if(v[i]>v[i+1]){
				a = v[i+1];
				v[i+1]=v[i];
				v[i]=a;
			}
		}
		return v;
	}
	
	static void p(double[] v, int i, double x) {
	    v[i] = x;
	    double[] u = {2.718, 3.14159};
	}
	


}