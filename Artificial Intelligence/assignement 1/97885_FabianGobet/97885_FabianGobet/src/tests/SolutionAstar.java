package tests;

import graph_utils.*;
import search_algorithms.*;

public class SolutionAstar {
	public static void main(String[] args) {
		
		Graph graph = new Graph();
		
		/*
		 * A heuristica utilizada aqui foi uma distância euclidiana nas seguintes condições:
		 *  - O mapa passa a estar seccionado em quadriculas do tamanho do maior maior lado do retangulo pertencente ao caminho entre as salas.
		 *  - Nesta condições, cada quadricula vale 1 unidade de medida, e tendo em conta a morfologia das salas, podemos calcular a 
		 *    distancia euclidiana minima entre duas(que é sempre otimista em relação à distancia verdadeira).
		 */
		
		Node n1 = new Node("1",2);
		Node n2 = new Node("2",8);
		Node n3 = new Node("3",11);
		Node n4 = new Node("4",14);
		Node n5 = new Node("5",1);
		Node n6 = new Node("6",18);
		Node n7 = new Node("7",15);
		Node n8 = new Node("8",15);
		Node n9 = new Node("9",8);
		Node n10 = new Node("10",16);
		Node n11 = new Node("11",0);
		
//		Node n1 = new Node("1",21);
//		Node n2 = new Node("2",13);
//		Node n3 = new Node("3",18);
//		Node n4 = new Node("4",26);
//		Node n5 = new Node("5",1);
//		Node n6 = new Node("6",30);
//		Node n7 = new Node("7",17);
//		Node n8 = new Node("8",13);
//		Node n9 = new Node("9",8);
//		Node n10 = new Node("10",29);
//		Node n11 = new Node("11",0);
		
		graph.addEdge(n6, n10,1); 
		graph.addEdge(n10,n4,3); 
		graph.addEdge(n4,n3,15); 
		graph.addEdge(n3,n9,3);
		graph.addEdge(n9,n7,9);
		graph.addEdge(n9,n11,9);
		graph.addEdge(n3,n11,19); 
		graph.addEdge(n4,n8,13); //13 
		graph.addEdge(n8,n5,13); 
		graph.addEdge(n5,n1,1);
		graph.addEdge(n5,n2,13);
		graph.addEdge(n5,n11,1); //1
		
		AStar star = new AStar(graph);
		star.printResult(star.startSearch(n6, n11));
		
	}
}
