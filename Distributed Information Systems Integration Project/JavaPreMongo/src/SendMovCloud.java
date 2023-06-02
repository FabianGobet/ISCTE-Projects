import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;

import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.util.*;
import java.util.List;
import java.util.stream.Collectors;
import java.text.SimpleDateFormat;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;


public class SendMovCloud extends Thread implements MqttCallback, KeyListener {
	private MqttClient mqttclient;
	private String cloud_server = new String();
	private String cloud_topic = new String();
	static JTextArea documentLabel = new JTextArea();
	private Date firstDate = new Date();
	private ArrayList<Sala> salas = new ArrayList<Sala>();
	private final int StartingRats = 50;


	public SendMovCloud() {

		cloud_server = "tcp://broker.mqtt-dashboard.com:1883";
		cloud_topic = "pisid_mazemov14";

		connecCloud();
		createWindow();
		// send();

	}

	public void connecCloud() {
		try {
			mqttclient = new MqttClient(cloud_server, "SimulateSensor" + cloud_topic, null);
			mqttclient.connect();
			mqttclient.setCallback(this);
			mqttclient.subscribe(cloud_topic);
		} catch (MqttException e) {
			e.printStackTrace();
		}
	}

	private void createWindow() {
		JFrame frame = new JFrame("Movs Sent");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		JLabel textLabel = new JLabel("Data from broker: ", SwingConstants.CENTER);
		textLabel.setPreferredSize(new Dimension(600, 30));
		JScrollPane scroll = new JScrollPane(documentLabel, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
				JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		scroll.setPreferredSize(new Dimension(600, 200));
		/*
		 * scroll.getVerticalScrollBar().addAdjustmentListener(new AdjustmentListener()
		 * {
		 * public void adjustmentValueChanged(AdjustmentEvent e) {
		 * e.getAdjustable().setValue(e.getAdjustable().getMaximum());
		 * }
		 * });
		 */
		JButton b1 = new JButton("Stop the program");
		frame.getContentPane().add(textLabel, BorderLayout.PAGE_START);
		frame.getContentPane().add(scroll, BorderLayout.CENTER);
		frame.getContentPane().add(b1, BorderLayout.PAGE_END);
		frame.setLocationRelativeTo(null);
		frame.pack();
		frame.setVisible(true);
		b1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent evt) {
				System.exit(0);
			}
		});
		documentLabel.setEditable(false);
		documentLabel.addKeyListener(this);
	}

	@Override
	public void connectionLost(Throwable cause) {
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {
	}

	@Override
	public void messageArrived(String topic, MqttMessage message) {
	}

	public void publishSensor(String leitura) {
		try {
			MqttMessage mqtt_message = new MqttMessage();
			mqtt_message.setPayload(leitura.getBytes());
			mqttclient.publish(cloud_topic, mqtt_message);
			documentLabel.append(mqtt_message.toString() + "\n");
		} catch (MqttException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		new SendMovCloud();

	}

	public void run() {
		resetMovs();
		Random rand = new Random();
		long start = System.currentTimeMillis();
		//SimpleDateFormat formatter = new SimpleDateFormat("\"yyyy-MM-dd HH:mm:ss.SSSSSS\"");
		//int i = 0;
		while (true) {
			//i++;
			// 420000 s�o 7m
			if (System.currentTimeMillis() - start > 420000) {
				resetMovs();
				start = System.currentTimeMillis();
			}

			try {
				Thread.sleep(Math.round(500 + (1500 - 500) * Math.random()));

			} catch (InterruptedException e) {
			}

			Double p = Math.random();
			String date = getDate();
			SimpleDateFormat formatter = new SimpleDateFormat("\"yyyy-MM-dd HH:mm:ss.SSSSSS\"");
			if (p < 0.995) {
				List<Sala> possibleSala = salas.stream().filter(a -> a.possibleChoice).collect(Collectors.toList());
				if (possibleSala.size() == 0) {
					System.out.println("Acabaram-se os movimentos possiveis");
					System.exit(0);
				}

				Sala primeiraSala = possibleSala.get(rand.nextInt(possibleSala.size()));
				Sala segundaSala = salas.get(primeiraSala.getRandomConnection() - 1);

				primeiraSala.removeRat();
				segundaSala.addRat();

				String s1 = "{Hora: " + formatter.format(new Date()) + ", SalaEntrada:" + primeiraSala.id + ", SalaSaida:" + segundaSala.id
						+ "}";

				publishSensor(s1);
			} else if (p >= 0.995 && p < 0.997) {
				String s1 = "{Hora: " + date + ", SalaEntrada:" + 1 + ", SalaSaida:" + 12 + "}";
				publishSensor(s1);
			} else if (p >= 0.997 && p < 0.999) {
				String s1 = "{Hora: " + date + ", SalaSaida:" + 1 + "}";
				publishSensor(s1);
			} else {
				String s1 = "{Hora: " + date + ", SalaEntrada:" + "\"oluiseumtoto\"" + ", SalaSaida:" + 4 + "}";
				publishSensor(s1);
			}

		}

		// publishSensor("{Hora: \"2021-03-02 10:51:12.000123\", SalaEntrada:" + "1" +
		// ", SalaSaida:" + 4 + "}");
		// publishSensor("{Hora: " + formatter.format(new Date()) + ", SalaEntrada:" +
		// "1" + ", SalaSaida:" + 4 + "}");
		// publishSensor("{Hora: \"2021-03-02 10:51:12.000123\", SalaEntrada:" + "1" +
		// ", SalaSaida:" + 4 + "}");

	}

	public void resetMovs() {
		createLab();
		publishSensor("{Hora:\"2000-01-01 00:00:00\", SalaEntrada:0, SalaSaida:0}");
	}

	public void createLab() {
		salas.removeAll(salas);
		Sala a = new Sala(1, StartingRats, new int[] { 2, 3 });
		salas.add(a);
		Sala b = new Sala(2, 0, new int[] { 4, 5 });
		salas.add(b);
		Sala c = new Sala(3, 0, new int[] { 2 });
		salas.add(c);
		Sala d = new Sala(4, 0, new int[] { 1, 5 });
		salas.add(d);
		Sala e = new Sala(5, 0, new int[] { 3, 6, 7 });
		salas.add(e);
		Sala f = new Sala(6, 0, new int[] { 8 });
		salas.add(f);
		Sala g = new Sala(7, 0, new int[] { 5 });
		salas.add(g);
		Sala h = new Sala(8, 0, new int[] { 9, 10 });
		salas.add(h);
		Sala i = new Sala(9, 0, new int[] { 7 });
		salas.add(i);
		Sala j = new Sala(10, 0, new int[] {});
		salas.add(j);
	}

	public String getDate() {

		Double p = Math.random();
		SimpleDateFormat formatter = new SimpleDateFormat("\"yyyy-MM-dd HH:mm:ss.SSSSSS\"");
		if (p < 0.05)
			return formatter.format(firstDate);
		else if (p >= 0.05 && p < 0.1)
			return "2023-04-0eX FA:EFUIJ.334";
		else
			return formatter.format(new Date());

		// return "\"20AA-03-02 10:51:12.000123\"";
	}

	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void keyPressed(KeyEvent e) {
		if (e.getKeyCode() == KeyEvent.VK_R) {
			resetMovs();
		}

	}

	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	public class Sala {
		private int id;
		private int numberOfRats;
		private int[] connections;
		private Random rand = new Random();
		private boolean possibleChoice;

		public Sala(int id, int numberOfRats, int[] connections) {
			this.id = id;
			this.numberOfRats = numberOfRats;
			this.connections = connections;
			checkPossibility();
		}

		public int getId() {
			return id;
		}

		public int getNumberOfRats() {
			return numberOfRats;
		}

		public int[] getConnections() {
			return connections;
		}

		public int getRandomConnection() {
			return connections[rand.nextInt(connections.length)];
		}

		private void checkPossibility() {
			if (numberOfRats > 0 && connections.length > 0)
				possibleChoice = true;
			else
				possibleChoice = false;
		}

		public void removeRat() {
			numberOfRats--;
			checkPossibility();
		}

		public void addRat() {
			numberOfRats++;
			checkPossibility();
		}

	}

}