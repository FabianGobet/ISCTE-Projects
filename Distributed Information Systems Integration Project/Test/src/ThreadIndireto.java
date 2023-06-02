import org.eclipse.paho.client.mqttv3.*;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Random;

public class ThreadIndireto extends Thread implements MqttCallback {

    private int count=0;
    private Connection conn;
    private Indireto indireto;
    private String cloudServer;
    private MqttClient mqttClient = null;
    private int checkNum= Generator.NUM_COMMANDS*3;

    public ThreadIndireto(Connection conn, Indireto indireto, String cloudServer){
        this.indireto=indireto;
        this.conn=conn;

        try {
            mqttClient = new MqttClient(cloudServer, "CommandsPosMongo" + "pisid_commands14" + new Random().nextInt(), null);
            mqttClient.connect();
            mqttClient.subscribe("pisid_commands14");
            mqttClient.setCallback(this);
        } catch (MqttException e) {
            throw new RuntimeException(e);
        }


    }

    @Override
    public void run() {

    }

    @Override
    public void connectionLost(Throwable throwable) {

    }

    @Override
    public void messageArrived(String s, MqttMessage mqttMessage) throws Exception {
        count++;
        var message = new String(mqttMessage.getPayload());
        if(message.toLowerCase().contains("call")){
            conn.prepareCall(message).execute();
        }else {
            conn.prepareStatement(message).execute();
        }
        if(count>=checkNum) {
            indireto.stopTimer();
        }

    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken iMqttDeliveryToken) {

    }
}
