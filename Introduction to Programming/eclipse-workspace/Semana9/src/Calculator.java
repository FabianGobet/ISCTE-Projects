class Calculator {

	int value;
	
	void plus (int n){
		value+=n;
	}
	
	void clean(){
		this.value=0;
	}
	
	void minus(int n){
		this.value = (n>this.value) ? 0 : value-n;
	}
	
	void multiply(int n){
		int val = this.value;
		for(int i=0; i<n-1; i++)
			this.value+=val;
	}
	
	void power(int n){
		int val=this.value;
		for(int i=0; i<n-1; i++)
			multiply(val);
	}
	
	void division(int n){
		int count=0;
		while(this.value>=n){
			minus(n);
			count++;
		}
		this.value=count;
	}
	
	void modulo(int n){
	int val = this.value;
	division(n);
	multiply(n);
	val-=this.value;
	this.value = val;
	}
	
	
//	static void test(){
//		Calculator calc = new Calculator();
//		calc.plus(6);
////		calc.power(4);
////		calc.division(2);
//		calc.modulo(2);
//	}
}

