package simulator;

import weka.classifiers.trees.J48;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;

public class MyTree {
	
	private J48 tree = new J48();
	Instances dataset;
	
	public MyTree(String fileName) {
		try {
			DataSource source = new DataSource(fileName);
			dataset = source.getDataSet();
			dataset.setClassIndex(dataset.numAttributes() - 1);
			tree.buildClassifier(dataset);
		} catch (Exception e) {
			System.out.println("Houston, we have a problem: Unable to either fetch data or train decision tree.");
			e.printStackTrace();
			System.exit(1);
		}
	}
	
	public void seeTree() {
		Visualizer v = new Visualizer();
		v.start(tree);
	}
	
	public J48 getTree() {
		return this.tree;
	}
	
	public double evaluate(String[] values){
		NewInstances ni = new NewInstances(dataset);
		ni.addInstance(values);
		Instance inst = ni.getDataset().instance(0);
		double res = 0;
		try {
			res = tree.classifyInstance(inst);
		} catch (Exception e) {
			System.out.println("Unable to make prediction.");
			e.printStackTrace();
			System.exit(1);
		}
		return res;
	}
	

}
