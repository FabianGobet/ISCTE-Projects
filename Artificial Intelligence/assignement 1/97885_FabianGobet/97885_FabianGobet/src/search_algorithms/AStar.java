package search_algorithms;

import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Set;

import graph_utils.Edge;
import graph_utils.Graph;
import graph_utils.Node;

public class AStar extends SearchAlgorithm{
	
	PriorityQueue<Edge> q;

	public AStar(Graph graph) {
		super(graph);
		q=new PriorityQueue<Edge>((e1,e2)->e1.getN1().getF()-e2.getN1().getF());
	}

	@Override
	public Edge getElement(Set s,List l) {
		Edge e = null;
		System.out.println(q);
		while(!(q.isEmpty() && e==null)) {
			e=q.poll();
			System.out.println(e);
			if(e==null) break;
			if(s.contains(e.getN1()) && e.getN1().getCost()>e.getN0().getCost()+e.getCost()) {
				Branch br = getBranchOfNode(e.getN1());
				br.parent=getBranchOfNode(e.getN0());
				e.getN1().setCost(e.getN0().getCost()+e.getCost());
				break;
			} else {
				//System.out.println(e.getN1().label);
				e.getN1().setCost(e.getN0().getCost()+e.getCost());
				l.add(new Branch(getBranchOfNode(e.getN0()),e.getN1()));
				break;
			}
		}
		return e;		
	}

	@Override
	public void saveElement(Edge e, Set s) {
		if(s.contains(e.getN1())) {
			if(e.getN1().getCost()>e.getN0().getCost()+e.getCost()) {
				q.removeIf(x->x.getN1().equals(e.getN1()));
				e.getN1().setCost(e.getN0().getCost()+e.getCost());
				q.add(e);
				s.add(e.getN1());
			}
		}else {
			e.getN1().setCost(e.getN0().getCost()+e.getCost());
			q.add(e);
			s.add(e.getN1());
		}	
	}

	@Override
	public void saveElement(List<Edge> le, Set s) {
		if(le!=null) {
			le.forEach(e->{
				e.getN1().setCost(e.getN0().getCost()+e.getCost());
				q.add(e);
				s.add(e.getN1());
			});;
		}
	}

	@Override
	public boolean isStructureEmpty() {
		return q.isEmpty();
	}
	

	

}
