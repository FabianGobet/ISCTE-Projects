package mqttmain;

import main.VarSet;
import org.eclipse.paho.client.mqttv3.*;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.sql.*;
import java.util.Properties;

public class SendMqttData extends Thread implements MqttCallback {

    MqttConnection mqttConnection;
    MqttClient mqttClient;

    public SendMqttData(MqttConnection mqttConnection){
        this.mqttConnection = mqttConnection;
        this.mqttClient = mqttConnection.connect();
        this.mqttClient.setCallback(this);
        /*try {
            this.mqttClient.connect();
        } catch (MqttException e) {
            throw new RuntimeException(e);
        }*/
    }


    @Override
    public void connectionLost(Throwable throwable) {

    }

    @Override
    public void messageArrived(String s, MqttMessage mqttMessage) throws Exception {

    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken iMqttDeliveryToken) {

    }

    @Override
    public void run() {
        Properties p = new Properties();

        // System.out.println(path);
        try {
            p.load(new FileInputStream("lib/sqlserver.properties"));
        } catch (IOException e) {
            return;
        }

        String c_type = p.getProperty("sql_connector_type");
        String host = p.getProperty("sql_host");
        String port = p.getProperty("sql_port");
        String db = p.getProperty("sql_db");
        String URL = c_type + "://" + host + ":" + port + "/" + db;
        // System.out.println(URL);

        String USER = p.getProperty("sql_user");
        String PASSWORD = p.getProperty("sql_user_password");

        String sqlQuery = "SELECT * FROM javaop";
        try {
            Connection sqlConn = DriverManager.getConnection(URL, USER, PASSWORD);
            while(true){

                Statement stmt = sqlConn.createStatement();
                ResultSet res = stmt.executeQuery(sqlQuery);
                VarSet varSet = new VarSet();

                ByteArrayOutputStream out = new ByteArrayOutputStream();
                ObjectOutputStream objOut = new ObjectOutputStream(out);

                if(res.next()){
                    varSet.setVars(res);
                    objOut.writeObject(varSet.getVars());
                    objOut.flush();
                    byte[] serializedObject = out.toByteArray();
                    this.mqttClient.publish(mqttConnection.getCloudTopic(), new MqttMessage(serializedObject));
                } else {
                    objOut.writeObject(new VarSet.Vars());
                    objOut.flush();
                    byte[] serializedObject = out.toByteArray();
                    this.mqttClient.publish(mqttConnection.getCloudTopic(), new MqttMessage(serializedObject));
                }

                try {
                    sleep(1000);
                } catch (InterruptedException e) {
                    return;
                }
            }
        } catch (SQLException | MqttException | IOException e) {
            throw new RuntimeException(e);
        }


    }
}
