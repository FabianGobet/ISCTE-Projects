
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.regex.Pattern;


import com.mongodb.BasicDBObject;
import com.mongodb.client.MongoCollection;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import com.mongodb.DBObject;
import org.bson.*;



public class TempThread extends Thread  implements MqttCallback{
	
	MqttClient mqttclient;

    static MongoCollection<Document> tempCol;
    public String cloudTopic;
    public String cloudServer;

    public MongoCollection<Document> logCol;
    
    public Date lastTimestamp;
    public DBObject dbObject;
    public int minutesRange = 1;
    static final long ONE_MINUTE_IN_MILLIS = 60000;
    
	
	public TempThread(MongoCollection<Document> logCol, String cloudTopic, String cloudServer, MongoCollection<Document> tempCol) {
		this.cloudTopic = cloudTopic;
		this.cloudServer=cloudServer;
		this.logCol = logCol;
		this.tempCol=tempCol;
		
	}


	@Override
	public void run() {
		connectCloud();
		
		
	}
	
	
	public void connectCloud() {
		int i;
        try {
			i = new Random().nextInt(100000);
            mqttclient = new MqttClient(cloudServer, "CloudToMongo_"+i+"_"+cloudTopic);
            mqttclient.connect();
            mqttclient.setCallback(this);
            mqttclient.subscribe(cloudTopic);
        } catch (MqttException e) {
            e.printStackTrace();
        }
    }


	@Override
	public void connectionLost(Throwable arg0) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void deliveryComplete(IMqttDeliveryToken arg0) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void messageArrived(String topic, MqttMessage c)
            throws Exception {
    	//System.out.println(c);
		CloudToMongo.documentLabel.append(c+"\n");
        try {
        	dbObject = BasicDBObject.parse(c.toString());
        	
            //System.out.println(dbObject.get("Hora"));
            
            //mongocol.insert(document_json).wasAcknowledged();  
            if(!checkSyntax()) {
            	//dbObject=createArbitraryObject();
            	//errorcol.insert(dbObject);
            	putErrorInMongo(c.toString());
            }
            
            else{
            	dbObject.put("numExp", CloudToMongo.getInstance().getNumExp());
				//movCol.insertOne(org.bson.Document.parse(dbObject.toString()));
				tempCol.insertOne(Document.parse(dbObject.toString()));
            }
                	                  
				//documentLabel.append(c.toString()+"\n");				
        } catch (Exception e) {
            System.out.println(e);
            putErrorInMongo(c.toString());
        }
    }
	
/*	public DBObject checkMessage(DBObject dbObject) {
    	String message = dbObject.toString();
    	message= message.substring(1,message.length()-1);
    	String[] keys = message.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    	//if(keys.length!=3) return false;
    	String result = "{";
    	result = result.concat("Hora:" + keys[0].split(":(?=(?:[^\\\"]*\\\"[^\\\"]*\\\")*[^\\\"]*$)")[1]);
    	result = result.concat(", SalaEntrada:" + keys[1].split(":")[1]);
    	result = result.concat(", SalaSa�da:" + keys[2].split(":")[1]);
    	return (DBObject) JSON.parse(result);    			
	}*/
	
	
	public boolean checkSyntax() {
		if(dbObject.toString().split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)").length != 3) return false;
		if(dbObject.get("Hora") == null  || dbObject.get("Leitura") == null 
				|| dbObject.get("Sensor") == null) return false;
		
		
		/*try {
			Double.parseDouble(dbObject.get("Leitura").toString());
			Integer.parseInt(dbObject.get("Sensor").toString());	
		}catch (NumberFormatException e) {
			return false;
		}*/
		
		checkTimestamp();
		
		return true;		
	}
	

	public DBObject createArbitraryObject() {
		SimpleDateFormat formatter = new SimpleDateFormat("\"yyyy-MM-dd HH:mm:ss.SSSSSS\"");
		String date = formatter.format(Utils.getCurrentDate());
		String s = "{Hora: "+ date + ", Leitura: -1, Sensor: -1}";
		return BasicDBObject.parse(s);
	}
	
	//{Hora: "2023-04-16 16:23:25.000070", Leitura: 13.312767711180555, Sensor: 2}
	public void checkTimestamp() {
		// Define regular expression pattern for the timestamp syntax
        String timestampPattern = "\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}(\\.\\d*)?";
        String timestamp = (String)dbObject.get("Hora");
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
        try {
			Date received = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);		
	        // Use Pattern.matcher() to check if the timestamp string matches the pattern
	        if (Pattern.matches(timestampPattern, timestamp) && isNewer(received, this.lastTimestamp)) {
	        	this.lastTimestamp=received;
	            System.out.println("Timestamp syntax is correct");
	        } else {
	            System.out.println("Timestamp syntax is incorrect or has an irrealistic time");
	            if(this.lastTimestamp!=null && checkIfTimeIsRecent(lastTimestamp, Utils.getCurrentDate())) {            	
	            	dbObject.put("Hora", formatter.format(this.lastTimestamp));
	            }
	            else dbObject.put("Hora", formatter.format(Utils.getCurrentDate()));	            
	        }
        } catch (ParseException e) {
        	System.out.println("Timestamp syntax is incorrect");
            if(this.lastTimestamp!=null && checkIfTimeIsRecent(lastTimestamp, Utils.getCurrentDate()))         	
            	dbObject.put("Hora", formatter.format(this.lastTimestamp));
            else dbObject.put("Hora", formatter.format(Utils.getCurrentDate()));           
		}
	}
	
	
	public boolean isNewer(Date recent, Date last) {
		if(last==null) {
			return checkIfTimeIsRecent(recent, Utils.getCurrentDate());
		}
		if(recent.compareTo(last) < 0) return false;
		if(checkIfTimeIsRecent(recent, last)) return true;
		if(checkIfTimeIsRecent(recent, Utils.getCurrentDate())) return true;
		return false;		
	}
	
	public boolean checkIfTimeIsRecent(Date recent, Date toCompare) {
		long curTimeInMs = toCompare.getTime();
	    Date maxDate = new Date(curTimeInMs + (this.minutesRange* ONE_MINUTE_IN_MILLIS));
	    Date minDate = new Date(curTimeInMs - (this.minutesRange* ONE_MINUTE_IN_MILLIS));
	    return (maxDate.compareTo(recent) >= 0 && recent.compareTo(minDate) >= 0);
	}
	
	public void putErrorInMongo(String message) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
		String result = "{Hora: \"" + formatter.format(Utils.getCurrentDate()) + "\", Message: \"" + message.replace("\"", "") + "\"}";
		System.out.println(result);
		dbObject = BasicDBObject.parse(result);
		logCol.insertOne(Document.parse(dbObject.toString()));
				
	}
		
	
}
