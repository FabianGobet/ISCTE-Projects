class matrizes {

		static int[][] linesWithNaturals(int lines){
			int[][] res = new int[lines][lines];
			for(int i=1; i!=res.length; i++){
				for(int j=0; j!=res[i].length; j++){
					res[i][j] = i+1;
				}
			}
			return res;
		}
		
		static boolean linesAreOrdered(int[][] matrix){
			for(int i=0; i<matrix.length; i++)
				for(int j=0; j<matrix[i].length-1; j++)
					if(matrix[i][j]>matrix[i][j+1]){
							return false;
					}
			return true;
				}
		
		static boolean test(){
			int[][] lala = {{1,2,3},{3,2,1}};
			return linesAreOrdered(lala);
		}
		
		static int[][] randomMatrix(int lines, int columns){
			int[][] matrix = new int[lines][columns];
			for(int i = 0; i<lines; i++)
				for(int j = 0; j<columns; j++)
					matrix[i][j] = (int)(Math.random()*10);
			return matrix;
		}
		
		static int[][] randomMatrix(int lines){
			return randomMatrix(lines, lines);
		}
		
		static int sumOfMatrix(int[][] matrix){
			int sum = 0;
			for(int i=0; i<matrix.length; i++)
				for(int j=0; j<matrix[i].length; j++)
					sum+=matrix[i][j];
			return sum;
		}
		
		static int elementsOfMatrix(int[][] matrix){
			int num = 0;
			for(int i=0; i<matrix.length; i++)
				for(int j=0; j<matrix[i].length; j++)
					num++;;
			return num;
		}
		
		
		static int[] unroll(int[][] matrix) {
			int[] vector = new int[elementsOfMatrix(matrix)];
			int k=0;
			for(int i=0; i<matrix.length; i++)
				for(int j=0; j<matrix[i].length; j++){
					vector[k]=matrix[i][j];
					k++;
				}
			return vector;
		}
		
		
		static int[][] matrixFrom(int[] v, int lines, int columns) {
			int k=0;
			int[][] matrix = new int[lines][columns];
			for(int i=0; i<lines && k<v.length; i++)
				for(int j=0; j<columns && k<v.length; j++){
					matrix[i][j]=v[k];
					k++;
				}
			return matrix;
		}
		
		static boolean isMatrixValid(int[][] matrix){
			for(int i=0; i<matrix.length-1; i++)
				if(matrix[i].length!=matrix[i+1].length)
					return false;
			return true;
		}
		
		static boolean squareMatrix(int[][] matrix){
			return isMatrixValid(matrix) && matrix.length==matrix[0].length;
		}
		
		
		static boolean isEqual(int[][] matrix1, int[][] matrix2){
			for(int i=0; i<matrix1.length; i++)
				for(int j=0; j<matrix1[i].length; j++)
					if(matrix1[i][j]!=matrix2[i][j])
						return false;
			return true;
		}
		
		
		static int[][] identity(int n) {
			int[][] matrix = new int[n][n];
			for(int i=0; i<n; i++)
				matrix[i][i] = 1;
			return matrix;
		}
		
		
		static void multiplyByScalar(int[][] matrix, int s) {
			for(int i=0; i<matrix.length; i++)
				for(int j=0; j<matrix[i].length; j++)
					matrix[i][j]*=s;
		}
		
		
		
		static void accumulate(int[][] m1, int[][] m2) {
			for(int i=0; i<m1.length; i++)
				for(int j=0; j<m1[i].length; j++)
					m1[i][j]+=m2[i][j];
		}
		
		static boolean isIdentity(int[][] matrix){
			return isEqual(matrix, identity(matrix.length));
		}
		
		
		static int[] columnVector(int[][] matrix, int col){
			int[] vector = new int[matrix.length];
			for(int i=0; i<matrix.length; i++)
				vector[i]=matrix[i][col];
			return vector;
		}
		
		
		static int[][] transpose(int[][] matrix){
			int[][] transposed = new int[matrix[0].length][matrix.length];
			for(int i=0; i<matrix.length; i++)
				for(int j=0; j<matrix[i].length-1; j++)
					transposed[j][i] = matrix[i][j];
			return transposed;
		}
		
		static boolean isSimetric(int[][] matrix){
			return isEqual(matrix, transpose(matrix));
		}
			
		
		
		static int multiplyRowColumn(int[][] m1, int[][] m2, int row, int column){
			int result = 0;
			for(int i=0; i<m2.length; i++)
				result+= m1[row][i]*m2[i][column];
			return result;
		}
					
		
		
		static int[][] matrixProduct(int[][] m1, int[][] m2){
			int[][] matrix = new int[m1.length][m2[0].length];
			for(int i=0; i<matrix.length; i++)
				for(int j=0; j<matrix[i].length; j++)
					matrix[i][j]=multiplyRowColumn(m1,m2,i,j);
			return matrix;
		}
		
		static int[][] testi(){
			int[][] t = randomMatrix(3,2);
			int[][] v = randomMatrix(2,3);
			//t[2]= new int[4];
			return matrixProduct(t,v);
		}
			
}