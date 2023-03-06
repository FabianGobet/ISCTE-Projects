package search_algorithms;

import java.util.ArrayList;
import java.util.List;

import graph_utils.Node;

public class Branch {
	
	public Branch parent;
	private Node node;
	
	public Branch(Branch parent, Node node) {
		this.parent=parent;
		this.node=node;
	}
	
	public List<Node> getPath(Node objective){
		List<Node> result = new ArrayList<>();
		Branch b = this;
		while(b!=null) {
			result.add(0,b.getNode());
			b=b.parent;
		}
		return result;
			
	}
	
	
	public Node getNode() {
		return this.node;
	}

}
