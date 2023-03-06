package search_algorithms;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Set;
import java.util.Stack;

import graph_utils.Edge;
import graph_utils.Graph;
import graph_utils.Node;

public class SearchDepth extends SearchAlgorithm{
	
	Stack<Edge> q = new Stack<>();

	public SearchDepth(Graph graph) {
		super(graph);
	}

	@Override
	public Edge getElement(Set s, List l) {
		Edge e = q.pop();
		if(e!=null) {
			s.add(e.getN1());
			Branch br = getBranchOfNode(e.getN0());
			buildBranch(br, e.getN1());
		}
		return e;
	}

	@Override
	public void saveElement(Edge e,Set s) {
		if(!s.contains(e.getN1())) {
			q.add(e);
		}
	}

	@Override
	public void saveElement(List<Edge> le, Set s) {
		if(le!=null) {
			le.forEach(e->{if(!s.contains(e.getN1())) q.add(e);});
		}
	}

	@Override
	public boolean isStructureEmpty() {
		return q.isEmpty();
	}

	

}
