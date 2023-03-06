package tests;

import java.util.List;

import graph_utils.*;
import search_algorithms.*;

public class SolutionBreadthDepth {
	public static void main(String[] args) {
		
		/*
		 * Este grafo está desenhado com as seguintes caracteristicas em consideração:
		 * 	- O objetivo é o Node n11
		 * 	- O ponto de partida é qualquer um, mas só exitem caminhos tendo em conta o grafo
		 * 	- Não podemos voltar para trás (não revisitamos nós)
		 * 
		 * Observações:
		 * 		Para pontos de partida e chegada diferentes teríamos de implementar grafos direcionados diferentes.
		 * 		Por outro lado, podemos tomar como solução genérica um grafo (não direcionado) que permite o 
		 * 		caminho para trás, isto é, existiria Edge(nX, nY) e Edge(nY,nX), mas cujas iterações nos algoritmos 
		 * 		de procura (Depth e Breadth) não permitissem andar para a casa anterior. 
		 * 		Posto isto, a solução pedida para este problema foi específica tendo em conta o exemplo, mas fica aqui como 
		 * 		observação que esta ideia está presente.
		 */

		Graph graph = new Graph();
		
		Node n1 = new Node("1");
		Node n2 = new Node("2");
		Node n3 = new Node("3");
		Node n4 = new Node("4");
		Node n5 = new Node("5");
		Node n6 = new Node("6");
		Node n7 = new Node("7");
		Node n8 = new Node("8");
		Node n9 = new Node("9");
		Node n10 = new Node("10");
		Node n11 = new Node("11");
		
		graph.addEdge(n6, n10);
		graph.addEdge(n10,n4);
		graph.addEdge(n4,n3);
		graph.addEdge(n3,n9);
		graph.addEdge(n9,n7);
		graph.addEdge(n9,n11);
		graph.addEdge(n3,n11);
		graph.addEdge(n4,n8);
		graph.addEdge(n8,n5);
		graph.addEdge(n5,n1);
		graph.addEdge(n5,n2);
		graph.addEdge(n5,n11);
		//System.out.println(graph+"\n");
		
		System.out.println("Breadth First Search");
		SearchBreadth bfs = new SearchBreadth(graph);
		bfs.printResult(bfs.start(n6, n11));
		System.out.println("\nDepth First Search");
		SearchDepth dfs = new SearchDepth(graph);
		dfs.printResult(dfs.start(n6, n11));
		
	}
}
