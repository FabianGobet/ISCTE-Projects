package pt.iul.poo.firefight.starterpack;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;


public class EndGameScreen{
	
	private JButton botao = new JButton("Play Again");
	private JButton botao2 = new JButton("Exit");
	JFrame frame = new JFrame("hihi");
	JLabel label = new JLabel("GAME OVER");
	JPanel panel ;
	Level lvl;
	
	public EndGameScreen(Level lvl) {
		this.lvl=lvl;
	}

	public void endGame() {
		Handler handler = new Handler();

		frame.setSize(800, 800);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setBackground(Color.black);
		frame.setLayout(null);
		frame.setResizable(false);
		
		botao.setBounds(300, 400, 200, 100);
        botao.setFont(botao.getFont().deriveFont(Font.PLAIN, 22));
        botao2.setFont(botao2.getFont().deriveFont(Font.PLAIN, 22));
        botao2.setBounds(300, 550, 200, 100);

        botao.addActionListener((ActionListener) handler);
        botao2.addActionListener((ActionListener) handler);
        
        label.setBounds(150, 75, 600, 200);
        label.setFont(new Font("Serif", Font.BOLD, 80));
        label.setForeground(Color.WHITE);

        frame.add(label);
		frame.add(botao);
		frame.add(botao2);

		ImageIcon icon = new ImageIcon("images/firemangif.gif");
		JLabel fireman = new JLabel(); 
		 fireman.setBounds(0,575,1200,300);
		   fireman.setIcon(icon);
		   frame.add(fireman, BorderLayout.SOUTH);


		frame.setVisible(true);
	}
	
	
	
	public class Handler implements ActionListener{

		@Override
		public void actionPerformed(ActionEvent e) {
			if(e.getSource() == botao) {
				lvl.changeLevel();
				frame.setVisible(false);
				frame.dispose();
			}
			if(e.getSource() == botao2) {
				System.exit(0);
			}	
		}	
	}
	
	
	
	
	
}
