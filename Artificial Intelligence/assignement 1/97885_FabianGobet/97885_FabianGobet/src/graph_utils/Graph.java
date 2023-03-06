package graph_utils;

import java.util.*;

/**
 * This class represents a Graph composed by a list of edges 
 * 
 * @author Rita Peixoto, Sancho Oliveira
 * @version 1.1
 *
 */
public class Graph {
	// List of edges
	private List<Edge> graph;
	// Adjacency list of the graph nodes and its respective neighbour edges
	private Map<Node, List<Edge>> adjacencyList; 
	
	// Constructor it initializes the list of edges and the adjacencyList
	public Graph() {
		graph = new LinkedList<Edge>();
		adjacencyList = new HashMap<Node, List<Edge>>();
	}

	// Add edge with a cost
	public void addEdge(Node n0, Node n1, int cost) {
		Edge e = new Edge(n0, n1, cost);
		graph.add(e);
		insertEdgeInAdjacentList(e);
	}

	// Add edge without a cost
	public void addEdge(Node n0, Node n1) {
		Edge e = new Edge(n0, n1);
		graph.add(e);
		insertEdgeInAdjacentList(e);
	}

	// Returns the number of edges
	public int getNumberOfEdges() {
		return graph.size();
	}

	// Returns the list of edges
	public List<Edge> getEdges() {
		return graph;
	}

	// Returns the adjacencyList
	public Map<Node, List<Edge>> getAdjacencyList() {
		return adjacencyList;
	}

	// Inserts the edge to the nodes adjacency list 
	private void insertEdgeInAdjacentList(Edge e) {
		if (adjacencyList.containsKey(e.getN0())) {
			adjacencyList.get(e.getN0()).add(e);
		} else {
			List<Edge> list = new ArrayList<>();
			list.add(e);
			adjacencyList.put(e.getN0(), list);
		}
	}


	// Returns the number of nodes
	public int numberOfNodes() {
		Set<Node> nodes = new HashSet<>();
		for (Edge e : graph) {
			nodes.add(e.getN0());
			nodes.add(e.getN1());
		}
		return nodes.size();
	}


	@Override
	public String toString() {
		String result = "";
		for (Edge e : graph) {
			result += e.toString() + "\n";
		}
		return result + "Number of Nodes: " + numberOfNodes();
	}

}
