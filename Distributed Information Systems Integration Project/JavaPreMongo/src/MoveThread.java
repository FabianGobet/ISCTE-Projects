
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.regex.Pattern;

import com.mongodb.BasicDBObject;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.mongodb.DBObject;


public class MoveThread extends Thread implements MqttCallback {

	MqttClient mqttclient;

	public String mongoCollection;
	static MongoCollection<Document> movCol;
	static MongoCollection<Document> logCol;
	public String cloudTopic;
	public String cloudServer;

	public String errorCollection;
	public MongoCollection<Document> errorcol;

	public Date lastTimestamp;
	public DBObject dbObject;
	public int maxMinRange = 2;
	public int minutesRange = 1;
	static final long ONE_MINUTE_IN_MILLIS = 60000;

	public MoveThread(MongoCollection<Document> logCol, String cloudTopic, String cloudServer, MongoCollection<Document> movCol) {
		this.logCol = logCol;
		this.movCol=movCol;
		this.cloudTopic = cloudTopic;
		this.cloudServer = cloudServer;


	}


	@Override
	public void run() {
		connectCloud();

	}

	public void connectCloud() {
		int i;
		try {
			i = new Random().nextInt(100000);
			mqttclient = new MqttClient(cloudServer, "CloudToMongo_" + String.valueOf(i) + "_" + cloudTopic,null);
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
		// System.out.println(c);
		CloudToMongo.documentLabel.append(c + "\n");
		try {
			String temp = c.toString();
			dbObject = BasicDBObject.parse(temp);
			// System.out.println(dbObject.get("Hora"));
			// mongocol.insert(document_json).wasAcknowledged();
			int format = checkSyntax();
			if (format == 0) {
				// dbObject=createArbitraryObject();
				putErrorInMongo(c.toString());
			} else if (format == 1) {
				movCol.insertOne(Document.parse(dbObject.toString()));

			}
			// documentLabel.append(c.toString()+"\n");
		} catch (Exception e) {
			putErrorInMongo(c.toString());
			System.out.println(e);
		}
	}

	/*
	 * public DBObject checkMessage(DBObject dbObject) {
	 * String message = dbObject.toString();
	 * message= message.substring(1,message.length()-1);
	 * String[] keys = message.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
	 * //if(keys.length!=3) return false;
	 * String result = "{";
	 * result = result.concat("Hora:" +
	 * keys[0].split(":(?=(?:[^\\\"]*\\\"[^\\\"]*\\\")*[^\\\"]*$)")[1]);
	 * result = result.concat(", SalaEntrada:" + keys[1].split(":")[1]);
	 * result = result.concat(", SalaSa�da:" + keys[2].split(":")[1]);
	 * return (DBObject) JSON.parse(result);
	 * }
	 */

	public int checkSyntax() {
		if (dbObject.toString().split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)").length != 3)
			return 0;
		if (dbObject.get("Hora") == null || dbObject.get("SalaEntrada") == null
				|| dbObject.get("SalaSaida") == null)
			return 0;

		dbObject.put("numExp", CloudToMongo.getInstance().getNumExp());

		int entrance;
		int exit;

		try {
			entrance = Integer.parseInt(dbObject.get("SalaEntrada").toString());
			exit = Integer.parseInt(dbObject.get("SalaSaida").toString());
			if (entrance == 0 && exit == 0) {
				CloudToMongo.getInstance().increaseNumExp();
				return -1;
				// CloudToMongo.getInstance().addToMazeManagementCollection();
			} 

		} catch (NumberFormatException e) {
		}
		
		checkTimestamp();
		return 1;
	}

	public DBObject createArbitraryObject() {
		SimpleDateFormat formatter = new SimpleDateFormat("\"yyyy-MM-dd HH:mm:ss.SSSSSS\"");
		String date = formatter.format(Utils.getCurrentDate());
		String s = "{Hora: " + date + ", SalaEntrada:-1, SalaSaida:-1}";
		return BasicDBObject.parse(s);
	}

	public void checkTimestamp() {
		// Define regular expression pattern for the timestamp syntax
		String timestampPattern = "\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}(\\.\\d*)?";
		String timestamp = (String) dbObject.get("Hora");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
		try {
			Date received = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);
			String date = formatter.format(received);

			// Use Pattern.matches() to check if the timestamp string matches the pattern
			if (Pattern.matches(timestampPattern, timestamp) && isNewer(received, this.lastTimestamp)) {
				dbObject.put("Hora", date);
				this.lastTimestamp = received;
				System.out.println("Timestamp syntax is correct");
			} else {
				System.out.println("Timestamp syntax is incorrect or has an irrealistic time");
				// errorcol.insert(dbObject);
				if (this.lastTimestamp != null && checkIfTimeIsRecent(lastTimestamp, Utils.getCurrentDate())) {
					dbObject.put("Hora", formatter.format(this.lastTimestamp));
				} else
					dbObject.put("Hora", formatter.format(Utils.getCurrentDate()));
				// else dbObject= null;
			}
		} catch (ParseException e) {
			System.out.println("Timestamp syntax is incorrect");
			if (this.lastTimestamp != null && checkIfTimeIsRecent(lastTimestamp, Utils.getCurrentDate()))
				dbObject.put("Hora", formatter.format(this.lastTimestamp));
			else
				dbObject.put("Hora", formatter.format(Utils.getCurrentDate()));
		}
	}

	public boolean isNewer(Date recent, Date last) {
		if (last == null) {
			return checkIfTimeIsRecent(recent, Utils.getCurrentDate());
		}
		if (recent.compareTo(last) < 0)
			return false;
		if (checkIfTimeIsRecent(recent, last))
			return true;
		if (checkIfTimeIsRecent(recent, Utils.getCurrentDate()))
			return true;
		return false;
	}

	public boolean checkIfTimeIsRecent(Date recent, Date toCompare) {
		long curTimeInMs = toCompare.getTime();
		Date maxDate = new Date(curTimeInMs + (this.minutesRange * ONE_MINUTE_IN_MILLIS));
		Date minDate = new Date(curTimeInMs - (this.minutesRange * ONE_MINUTE_IN_MILLIS));
		return (maxDate.compareTo(recent) >= 0 && recent.compareTo(minDate) >= 0);

	}

	public void putErrorInMongo(String message) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
		String result = "{Hora: \"" + formatter.format(Utils.getCurrentDate()) + "\", Message: \"" + message.replace("\"", "") + "\"}";
		System.out.println(result);
		dbObject = BasicDBObject.parse(result);
		logCol.insertOne(Document.parse(dbObject.toString()));
		//errorcol.insert(dbObject);


	}

}
