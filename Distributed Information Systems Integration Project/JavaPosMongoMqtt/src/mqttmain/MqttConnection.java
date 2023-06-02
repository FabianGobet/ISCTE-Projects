package mqttmain;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Properties;
import java.util.Random;

public class MqttConnection {
    private MqttClient mqttClient;

    private String mongoUser = new String();
    private String mongoPassword = new String();
    private String mongoAddress = new String();
    private String mongoReplica = new String();
    private String mongoDatabase = new String();
    private String mongoAuthentication = new String();
    private Topic topic;
    private String cloudServer, cloudTopicReceiveCommands, cloudTopicSendData;

    private ArrayList<String> collections = new ArrayList<>();

    public MqttConnection(Topic topic) {

        Properties p = new Properties();
        try {
            p.load(new FileInputStream("lib/MongoProperties.properties"));
        } catch (IOException e) {
            return;
        }
        mongoAddress = p.getProperty("mongo_address");
        mongoUser = p.getProperty("mongo_user");
        mongoPassword = p.getProperty("mongo_password");
        mongoReplica = p.getProperty("mongo_replica");
        mongoDatabase = p.getProperty("mongo_database");
        mongoAuthentication = p.getProperty("mongo_authentication");

        cloudServer = p.getProperty("cloud_server");
        cloudTopicReceiveCommands = p.getProperty("cloud_topic_commands");
        cloudTopicSendData = p.getProperty("cloud_topic_sql_data");
        for (String prop :
                new ArrayList<String>(Arrays. asList("mongo_maze_collection", "mongo_move_collection", "mongo_temp_collection", "mongo_error_collection"))) {
            collections.add(p.getProperty(prop));
        }


        try {
            mqttClient = new MqttClient(cloudServer, "CommandsPosMongo" + topic.toString() + new Random().nextInt(), null);
            this.topic = topic;
            mqttClient.connect();
            mqttClient.subscribe(getCloudTopic());

        } catch (MqttException e) {
            e.printStackTrace();
        }
    }

    public String getCloudTopic(){
        return topic == Topic.receive ? cloudTopicReceiveCommands : cloudTopicSendData;
    }


    public MqttClient connect(){
        return mqttClient;
    }

}

