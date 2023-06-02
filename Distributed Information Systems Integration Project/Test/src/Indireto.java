
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

public class Indireto extends Thread{

        private MqttClient mqttClient;
        private Connection conn;
        private List<String> calls;
        private List<String> inserts;
        private Long ti, tf;
        private String cloudServer;
        private List<String> finalList = new ArrayList<>();

        public Indireto(Connection conn, List<String> calls, List<String> inserts){
            this.conn=conn;
            this.calls=calls;
            this.inserts=inserts;

            finalList.addAll(inserts);
            finalList.addAll(calls);

            Properties p = new Properties();
            try {
                p.load(new FileInputStream("lib/MongoProperties.properties"));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            cloudServer = p.getProperty("cloud_server");

            try {
                mqttClient = new MqttClient(cloudServer, "CommandsPosMongo" + "pisid_commands14" + new Random().nextInt(), null);
                mqttClient.connect();
                mqttClient.subscribe("pisid_commands14");
            } catch (MqttException e) {
                throw new RuntimeException(e);
            }


        }

        public List<Long> runTest(){

            ThreadIndireto threadind = new ThreadIndireto(conn, this, cloudServer);
            threadind.start();
            try {
                sleep(1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            ti = System.nanoTime();
            doStuff();
            while(tf==null) {

                try {
                    sleep(1000);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
            threadind.interrupt();
            return new ArrayList<>(Arrays.asList(ti,tf,tf-ti));
        }

        public void stopTimer(){
            tf = System.nanoTime();
        }

        public void doStuff() {
            for(String c : finalList) {
                try {
                    MqttMessage ms = new MqttMessage(c.getBytes());
                    //ms.setQos(2);
                    mqttClient.publish("pisid_commands14",ms);
                } catch (MqttException e) {
                    throw new RuntimeException(e);
                }
            }
        }


}
