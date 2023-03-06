package graph_utils;

/**
 * This class represents Edges of a Graph
 * This edges are directed from Node n0 to Node n1 (n0-->n1)
 * 
 * @author Rita Peixoto
 * @version 1.0
 *
 */
public class Edge {

	private Node n0;
	private Node n1;
	private int cost;

	//Constructor with cost value
	public Edge(Node n0, Node n1, int cost) {
		this.cost = cost;
		this.n0 = n0;
		this.n1 = n1;
	}

	//Constructor without cost value
	public Edge(Node n0, Node n1) {
		cost = 0;
		this.n0 = n0;
		this.n1 = n1;
	}

	//returns the cost
	public int getCost() {
		return cost;
	}
	
	/* This procedure is used to change the cost value of an edge
	 * It throws an IllegalArgumentException on invalid value of cost (<0)
	 */
	public void setCost(int cost) {
		if (cost < 0)
			throw new IllegalArgumentException("Invalid value of edge cost");
		this.cost = cost;
	}

	//Returns origin node of the edge
	public Node getN0() {
		return n0;
	}

	//Return final node of the edge
	public Node getN1() {
		return n1;
	}
	
	@Override
	public String toString() {
		return n0.getLabel() + " -> " + n1.getLabel() + " , cost = " + cost+" , F= "+n1.getF();
	}

}
