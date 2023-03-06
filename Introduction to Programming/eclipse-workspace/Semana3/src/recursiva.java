class recursiva {
	
	static int fact(int n){
		if(n==0){
			return n;
		} else {
			return n*fact(n-1);
		}
	}
	
	static int iterFact(int n){
		int fact=1;
		for(int i=1; i<=n; i++){
			fact*=i;
		}
		return fact;
	}
	
	static int numberOfDivisers(int n){
		int i=1;
		int num = 0;
		while(i<=n){
			if(n%i==0){
				num++;
			}
			i++;
		}
		return num;
	}
	
	static int sumOfDivisers(int n){
		int i=1;
		int num = 0;
		while(i<n){
			if(n%i==0){
				num+=i;
			}
			i++;
		}
		return num;
	}
	
	static boolean isPrime(int n){
		return numberOfDivisers(n)==2 && n!=1;
	}
	
	static int sumOfPrimesSmallerThan(int n){
		int i=1;
		int sum = 0;
		while(i<n){
			if(isPrime(i)){
				sum+=i;
			}
			i++;
		}
		return sum;
	}
	
	
	static int numberOfPrimesUpTo(int n){
		int i=1;
		int count = 0;
		while(i<=n){
			if(isPrime(i)){
				count++;
			}
			i++;
		}
		return count;
	}
	
	static boolean isPerfect(int n){
		return sumOfDivisers(n)==n;
	}
	
	
	static int numberOfPerfectsUpTo(int n){
		int count = 0;
		int i = 1;
		while(i<=n){
			if(isPerfect(i)){
				count++;
			}
			i++;
		}
		return count;
	}
	
	
	static boolean existsPrimeBetween(int a, int b){
		int i=a+1;
		while(i<b){
			if(isPrime(i)){
				return true;
			}
			i++;
		}
		return false;
	}
	
	
	static int fibonacci(int n){
		if(n==0){
			return 0;
		} else if(n==1){
			return 1;
		} else {
			return fibonacci(n-1) + fibonacci(n-2);
		}
	}
	
	
	static int factorial(int n){
		if(n==1){
			return 1;
		} else{
			return n*factorial(n-1);
		}
	}
		
	
	
	
	static int gcd(int a,int b) {
		  if (b==0) 
		    return a;
		  else
		    return gcd(b, a % b);
		}
	
	
	
}