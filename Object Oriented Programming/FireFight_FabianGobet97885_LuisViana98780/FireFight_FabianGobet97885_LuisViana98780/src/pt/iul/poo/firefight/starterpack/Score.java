package pt.iul.poo.firefight.starterpack;

import java.io.File;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Scanner;
import javax.swing.JOptionPane;

public class Score {
	
	private String username;
	private int points=0;
	private GameEngine ge = GameEngine.getInstance();
	
	private Comparator<String> comp = new Comparator<String>() {
		public int compare(String str1, String str2){
			String[] data1 = str1.split(" ");
			String[] data2 = str2.split(" ");
			return Integer.parseInt(data2[0])-Integer.parseInt(data1[0]);
		}
	};

	
	public Score() {
		String welcome="BEM VINDO!\n\n\nAs teclas para jogar sao:\n\nSetas de direcao  >  mover o bombeiro\nP  >  chamar aviao\nL  >  trocar de bombeiro\nENTER  >  sair do veiculo\n\n\nIntroduza o username:";
		String username = "";
		while(username.isEmpty()) {
			username = JOptionPane.showInputDialog(welcome);
			if(username==null)
				System.exit(0);
		}
		this.username=username;
		updateMessage();
	}
	
	public void updateMessage() {
		ge.gui.setStatusMessage(getUserPoints());
	}
	
	public void savePoints() {
		PriorityQueue<String> temp = new PriorityQueue<>(comp);
		File f= new File("./levels/"+ge.lvls.currentFileName().replace(".txt","")+"_pontos.txt");
		String msg="";
		try {
			f.createNewFile();
			Scanner sc = new Scanner(f);
			while(sc.hasNext()) {
				temp.add(sc.nextLine());
			}
			sc.close();
			temp.add(getUserPoints());
			PrintWriter pw = new PrintWriter(f);
			msg="";
			int j=temp.size();
			for(int i=0; i<5 && i<j; i++) {
				String aux = temp.poll();
				pw.println(aux);
				msg+=aux+'\n'; 
			}
			pw.close();
			
		} catch (IOException e) {
			System.err.println("Impossivel ler ou criar ficheiro.");
			System.exit(0);
		}
		showPointsMessage(msg);
		this.points=0;
	}
	
	public void showPointsMessage(String msg) {
		String message = "Your Score:  "+getUserPoints()+"\n\nTop Scores:\n"+msg;
		JOptionPane.showMessageDialog(null,message);
		
	}
	
	
	
	public int getPoints() {
		return points;
	}
	
	
	
	public void addPoints(int points) {
		this.points+=points;
	}
	
	
	
	public String getUserPoints() {
		if(this.points<0)
			this.points=0;
		return this.points+" "+this.username;
	}
	
	

}
