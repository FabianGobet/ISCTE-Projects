package simulator;

import net.sourceforge.jFuzzyLogic.FIS;
import net.sourceforge.jFuzzyLogic.FunctionBlock;
import net.sourceforge.jFuzzyLogic.rule.Rule;

public class MyActions {
	
	private FunctionBlock fb;
	/////////////////////
	FIS fis;
	public MyActions(String filename) {
		this.fis = FIS.load(filename, true);

		if (fis == null) {
			System.err.println("Can't load file: '" + filename + "'");
			System.exit(1);
		}
		fb = fis.getFunctionBlock(null);
	}
	
	public double[] evaluate(double leftSensor, double middleSensor, double rightSensor, double mushie) {	
		
		fb.setVariable("leftSensor", leftSensor);
		fb.setVariable("middleSensor", middleSensor);
		fb.setVariable("rightSensor", rightSensor);
		fb.setVariable("mushie", mushie);
		fb.evaluate();
		fb.getVariable("action").defuzzify();
		fb.getVariable("turnAngle").defuzzify();
/*		if(mushie!=0.5) {
			
			for(Rule r : fis.getFunctionBlock("mushieFunc").getFuzzyRuleBlock("No1").getRules() )
				System.out.println(r);
		}
*/		
		double[] res = {fb.getVariable("turnAngle").getValue(),fb.getVariable("action").getValue()};
		
		return res;
	}
	
}
