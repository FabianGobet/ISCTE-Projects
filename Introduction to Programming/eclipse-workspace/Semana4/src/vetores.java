class vetores {
	
	static int[] naturals(int n){
		int[] v = new int[n];
		int i = 0;
		while(i<n){
			v[i] = i+1;
			i++;
		}
		return v;
	}
	
	static int vectorsum(int[] v){
		int i = 0;
		int sum = 0;
		while(i<v.length){
			sum = sum + v[i];
			i++;
		}
		return sum;
	}
	
	static int[] ramdom(int n){
		int i = 0;
		int[] v = new int[n];
		while(i<n){
			double d = Math.random() * 10;
			v[i] = (int)d;
			i++;
		}
		return v;
	}
	
	
	static double average(int[] v){
		double a = (double)vectorsum(v)/(v.length);
		return a;
	}
		
	
	static int[] replicate(int[] v, int n){
		int[] a = new int[n];
		int i = 0 ;
		while(i<n){
			a[i] = v[i];
			i++;
		}
		return a;
	}
	
	static boolean exists(int n, int[] v){
		int i = 0;
		while(i<v.length){
			if(n==v[i]){
				return true;
			}
			i++;
		}
		return false;
	}
	
	
	static int count(int n, int[] v){
		int i = 0;
		int count = 0;
		while(i<v.length){
			if(n==v[i]){
				count++;
			}
			i++;
		}
		return count;
	}
	
	
	static int max(int[] v){
		int i = 1;
		int max = v[0];
		while(i<v.length){
			if(max<v[i]){
				max = v[i];
			}
			i++;
		}
		return max;
	}
	
	static int[] subcopy(int a, int b, int[] v){
		int[] v2 = new int[b-a+1];
		int i = a;
		while(i<=b){
			v2[i-a]=v[i];
			i++;
		}
		return v2;
	}
	
	
	static int[] firstHalf(boolean middle, int[] v){
		int end = v.length/2;
		if(!middle){
			end--;
		}
		return subcopy(0,end,v);
	}
	
	
	static int[] secondHalf(boolean middle, int[] v){
		int beggining = v.length/2;
		if(!middle){
			beggining++;
		}
		return subcopy(beggining, v.length-1,v);
	}
	
	
	static int[] merge(int[] a, int[] b){
		int[] v = new int[a.length + b.length];
		int i = 0;
		while(i<a.length){
			v[i] = a[i];
			i++;
		}
		while(i<a.length+b.length){
			v[i] = b[i-a.length];
			i++;
		}
		return v;
	}

	
	static int[] invert(int[] v){
		int i = 0;
		int[] a = new int[v.length];
		while(i<v.length){
			a[i] = v[v.length-i-1];
			i++;
		}
		return a;
	}
	
	
	static int ramdom(int[] v){
		int d = (int)(Math.random()* 10 / (v.length-1));
		return v[d];
	}

	

		static int test(){
			int[] v = new int[5];
			int i = 1;
			while(i != v.length) {
			    v[i] = 3;
			    i = i + 1;
			}
			return v[0];
			
}