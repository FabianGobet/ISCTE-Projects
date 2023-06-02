package mqttmain;

import org.eclipse.paho.client.mqttv3.*;
import org.mariadb.jdbc.export.Prepare;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class ReceiveMqttData extends Thread implements MqttCallback {
    MqttConnection mqttConnection;
    MqttClient mqttClient;

    Connection sqlConn;

    public ReceiveMqttData(MqttConnection mqttConnection){
        this.mqttConnection = mqttConnection;
        this.mqttClient = mqttConnection.connect();
        mqttClient.setCallback(this);
        /*try {
            mqttClient.connect();
        } catch (MqttException e) {
            throw new RuntimeException(e);
        }*/
        connectSQL();
    }

    public void connectSQL(){
        Properties p = new Properties();
        try {
            p.load(new FileInputStream("lib/sqlserver.properties"));
        } catch (IOException e) {
        }
        String c_type = p.getProperty("sql_connector_type");
        String host = p.getProperty("sql_host");
        String port = p.getProperty("sql_port");
        String db = p.getProperty("sql_db");
        String URL = c_type + "://" + host + ":" + port + "/" + db;
        String USER = p.getProperty("sql_user");
        String PASSWORD = p.getProperty("sql_user_password");

        try {
            sqlConn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    @Override
    public void connectionLost(Throwable throwable) {

    }

    @Override
    public void messageArrived(String s, MqttMessage mqttMessage) throws Exception {

        var message = new String(mqttMessage.getPayload());
        System.out.println(message);
        if(message.toLowerCase().contains("call")){
            CallableStatement cs = sqlConn.prepareCall(message);
            cs.execute();
        }else {
            PreparedStatement ps = sqlConn.prepareStatement(message);
            ps.execute();
        }

    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken iMqttDeliveryToken) {

    }

    @Override
    public void run() {
        System.out.println(mqttClient.getClientId());
    }
}
