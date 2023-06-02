package mqttmain;

import org.eclipse.paho.client.mqttv3.MqttClient;

public class Main {
    public static void main(String[] args) {

        (new ReceiveMqttData(new MqttConnection(Topic.receive))).start();
        (new SendMqttData(new MqttConnection(Topic.send))).start();
    }
}