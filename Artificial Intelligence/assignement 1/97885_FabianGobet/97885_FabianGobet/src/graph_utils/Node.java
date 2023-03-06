package graph_utils;

/**
 * This class represents Nodes of a Graph
 * A Node is an object of value
 * 
 * @author Rita Peixoto
 * @version 1.1
 *
 */

public class Node {
	public String label;
	private int heuristic = 0;
	// cost value of the edges to get to this node
	private int cost = 0;

	// Constructor without heuristic value
	public Node(String label) {
		this.label = label;
	}

	// Constructor with heuristic value
	public Node(String label, int heuristic) {
		this.label = label;
		this.heuristic = heuristic;
	}

	/* This procedure is used to change the heuristic value of a Node
	 * It throws an IllegalArgumentException on invalid value of heuristic (<0)
	 */
	public void setHeuristic(int heuristic) {
		if (heuristic < 0)
			throw new IllegalArgumentException("Invalid value of heuristic");
		this.heuristic = heuristic;
	}

	// Returns the label
	public String getLabel() {
		return label;
	}

	// Returns the heuristic
	public int getHeuristic() {
		return heuristic;
	}

	// This procedure changes the cost value (of the edges) to get to this node
	public void setCost(int cost) {
		this.cost = cost;
	}
	
	// Returns the cost value
	public int getCost() {
		return cost;
	}
	
	// Returns the F value (for astar algorithm)
	public int getF() {
		return cost + heuristic;
	}
	
	// Method to compare Nodes, two Nodes are equal if they have the same String label
	@Override
	public boolean equals(Object n) {
		return ((Node) n).getLabel().equals(getLabel());
	}
	
	@Override
	public int hashCode() {
		return label.hashCode();
	}
	
	@Override
	public String toString() {
		return label;
	}

}
