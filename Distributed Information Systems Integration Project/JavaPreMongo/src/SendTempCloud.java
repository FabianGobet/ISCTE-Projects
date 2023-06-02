import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;

import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.text.SimpleDateFormat;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

import java.util.Date;

public class SendTempCloud extends Thread implements MqttCallback {
	private MqttClient mqttclient;
	private String cloud_server = new String();
	private String cloud_topic = new String();
	private Date firstDate = new Date();
	static JTextArea documentLabel = new JTextArea();

	public SendTempCloud() {

		cloud_server = "tcp://broker.mqtt-dashboard.com:1883";
		cloud_topic = "pisid_mazetemp14";
		createWindow();
		connecCloud();
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

	private void createWindow() {
		JFrame frame = new JFrame("Temps Sent");
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
	}

	public void run() {
		Double temp1 = 10d;
		Double temp2 = 10d;
		Double aux1;
		Double aux2;
		int i = 0;
		while (true) {
			i++;
			try {
				Thread.sleep(Math.round(800 + (1200 - 800) * Math.random()));
			} catch (InterruptedException e) {
			}

			Double p = Math.random();
			if (p < 0.9) {

				// TEMP 1
				aux1 = getTemp(temp1);
				if (aux1 != 50)
					temp1 = aux1;

				// TEMP 2
				aux2 = getTemp(temp2);
				if (aux2 != 50)
					temp2 = aux2;

				String date = getDate();

				String s1 = "{Hora: " + date + ", Leitura: " + aux1 + ", Sensor: " + getSensor("1") + "}";
				String s2 = "{Hora: " + date + ", Leitura: " + aux2 + ", Sensor: " + getSensor("2") + "}";

				publishSensor(s1);
				publishSensor(s2);
			} else {
				String date = getDate();
				String s1 = "{Hratdfa: " + date + ", Leitsfdsf:" + 14 + ", JjdAuHPJoho:" + 1 + "}";
				publishSensor(s1);

			}

		}
	}

	public Double getTemp(double temp) {
		Double p = Math.random();
		if (p < 0.05)
			return 50d;

		Double r = Math.random();
		// randomValue = rangeMin + (rangeMax - rangeMin) * r);
		return temp - 0.5 + (temp + 0.5 - (temp - 0.5)) * r;
	}

	public String getSensor(String sensor) {
		Double p = Math.random();
		if (p < 0.05)
			return "\"XgDd\"";
		return sensor;
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
	}

	public static void main(String[] args) {
		new SendTempCloud();
	}

}