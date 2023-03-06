package search_algorithms;

import java.util.*;
import graph_utils.*;

/**
 * This abstract class represents a general search algorithm
 * 
 * @author Rita Peixoto, Sancho Oliveira
 * @version 1.1
 *
 */

public abstract class SearchAlgorithm{

	// The graph which represents the search space
	private Graph graph;
	// The adjacency list of the graph
	private Map<Node, List<Edge>> adjacencyList;
	
	private Set<Node> discovered = new HashSet<>();
	private List<Branch> branches = new ArrayList<>();

	// Constructor, graph as parameter
	public SearchAlgorithm(Graph graph) {
		this.graph = graph;
		adjacencyList = graph.getAdjacencyList();
	}

	// Returns the graph
	public Graph getGraph() {
		return graph;
	}

	// Returns the adjacency list of a Node, a list of edges to the neighbors nodes
	public List<Edge> adjacencyOfNode(Node n) {
		return adjacencyList.get(n);
	}
	
	
	/*
	 *  Metodos que devem implementar funcionalidade de acordo com a estrutura de dados do algoritmo escolhido
	 */
	
	//getElement() devolve o proximo elemento a ser processado da estrutura de dados
	public abstract Edge getElement(Set s,List l);
	//metodo saveElement que guarda um elemento do tipo Edge na estrutura de dados
	public abstract void saveElement(Edge e,Set s);
	//metodo SaveElement que guarda uma lista de elementos Edge na estrutura de dados
	public abstract void saveElement(List<Edge> le, Set s);
	//metodo isStructureEmpty que verifica se a estrutura de dados esta vazia
	public abstract boolean isStructureEmpty();
	
	
	
	public List<Node> startSearch(Node n_initial, Node n_final) {
		List<Node> result = new ArrayList<Node>();
		if (n_initial.equals(n_final)) {
			result.add(n_initial);
			System.out.println("Initial node is equal to the final node");
			return result;
		} else {
			result = start(n_initial, n_final);
			return result;
		}
	}
	
	
	public List<Node> start(Node n_initial, Node n_final){
		List<Node> path = new ArrayList<>();
		saveElement(adjacencyOfNode(n_initial),discovered);
		buildBranch(null,n_initial);
		while(!isStructureEmpty()) {
			Edge e = getElement(discovered,branches);
			if(e==null) break;
			if(e.getN1().equals(n_final)) {
				return getBranchOfNode(e.getN1()).getPath(e.getN1());
			} else {
				List<Edge> adjacency = adjacencyOfNode(e.getN1());
				if(adjacency!=null)
					for(Edge e2:adjacency)
						saveElement(e2,discovered);
							
			}
		}
		return path;
	}
	
	
	// O branch da lista que contém o Node n
	public Branch getBranchOfNode(Node n) {
		for(Branch b : branches) 
			if(b.getNode().equals(n))
				return b;
		return null;
	}
	
	// Função que recebe o Node e constroi uma estrutura que o contem e aponta para de onde vem (em relação ao caminho)
	public void buildBranch(Branch parent, Node self) {
		branches.add(new Branch(parent,self));
		if(parent!=null) discovered.add(parent.getNode());
	}
	
	
	public void printResult(List<Node> list) {
		System.out.println("Search Result:");
		String result = "";
		for (Node n : list) {
			if (list.get(list.size() - 1).equals(n)) {
				result += n.getLabel();
			} else {
				result += n.getLabel() + "->";
			}
		}
		System.out.println(result);
	}
}
