
import com.mongodb.*;
import com.mongodb.client.*;

import static com.mongodb.client.model.Sorts.descending;

import java.util.*;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.io.*;
import javax.swing.*;
import org.bson.Document;

import java.awt.*;
import java.awt.event.*;

public class CloudToMongo {

	public static JTextArea documentLabel = new JTextArea("\n");
	private static CloudToMongo single_instance = null;

	private MongoDatabase db;
	private String mongo_user = new String();
	private String mongo_password = new String();
	private String mongo_address = new String();
	private String mongo_replica = new String();
	private String mongo_database = new String();
	private String mongo_authentication = new String();
	// private JTextArea documentLabel = new JTextArea("\n");
	// private String mongo_maze_collection = new String();
	private String mongo_move_collection = new String();
	private String mongo_temp_collection = new String();
	private String mongo_error_collection = new String();
	private String cloud_mov_topic = new String();
	private String cloud_temp_topic = new String();
	private String cloud_server = new String();
	private int numExp;
	public MongoCollection<Document> mazeCol;
	public MongoCollection<Document> moveCol;
	public MongoCollection<Document> tempCol;
	public MongoCollection<Document> logCol;
	private Lock lock = new ReentrantLock();


	public static synchronized CloudToMongo getInstance() {
		if (single_instance == null)
			single_instance = new CloudToMongo();

		return single_instance;
	}

	private void createWindow() {
		JFrame frame = new JFrame("Cloud to Mongo");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		JLabel textLabel = new JLabel("Data from broker: ", SwingConstants.CENTER);
		textLabel.setPreferredSize(new Dimension(600, 30));
		JScrollPane scroll = new JScrollPane(documentLabel, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
				JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		scroll.setPreferredSize(new Dimension(600, 200));
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
	}

	public CloudToMongo() {
		createWindow();
		try {

			Properties p = new Properties();
			// System.out.println("------------------------------------------"+System.getProperty("user.dir"));
			// p.load(new
			// FileInputStream("lib/MongoProperties.properties"));

			p.load(new FileInputStream("lib/MongoProperties.properties"));
			mongo_address = p.getProperty("mongo_address");
			mongo_user = p.getProperty("mongo_user");
			mongo_password = p.getProperty("mongo_password");
			mongo_replica = p.getProperty("mongo_replica");
			mongo_database = p.getProperty("mongo_database");
			mongo_authentication = p.getProperty("mongo_authentication");
			// mongo_maze_collection = p.getProperty("mongo_maze_collection");
			mongo_move_collection = p.getProperty("mongo_move_collection");
			mongo_temp_collection = p.getProperty("mongo_temp_collection");
			cloud_mov_topic = p.getProperty("cloud_mov_topic");
			cloud_temp_topic = p.getProperty("cloud_temp_topic");
			cloud_server = p.getProperty("cloud_server");

			mongo_error_collection = p.getProperty("mongo_error_collection");
		} catch (Exception e) {
			System.out.println("Error reading CloudToMongo.ini file " + e);
			JOptionPane.showMessageDialog(null, "The CloudToMongo.ini file wasn't found.", "CloudToMongo",
					JOptionPane.ERROR_MESSAGE);
		}

		connectMongo();

		this.numExp = getNumExpFromMongo();
		increaseNumExp();
		System.out.println(this.numExp);
		// addToMazeManagementCollection();
		
		new MoveThread(logCol, cloud_mov_topic, cloud_server, moveCol).start();
		new TempThread(logCol, cloud_temp_topic, cloud_server, tempCol).start();

	}

	public void connectMongo() {
		String mongoURI = new String();
		mongoURI = "mongodb://";
		if (mongo_authentication.equals("true"))
			mongoURI = mongoURI + mongo_user + ":" + mongo_password + "@";
		mongoURI = mongoURI + mongo_address;
		if (!mongo_replica.equals("false"))
			if (mongo_authentication.equals("true"))
				mongoURI = mongoURI + "/?replicaSet=" + mongo_replica + "&authSource=mqttData";
			else
				mongoURI = mongoURI + "/?replicaSet=" + mongo_replica;
		else if (mongo_authentication.equals("true"))
			mongoURI = mongoURI + "/?authSource=mqttData&readPreference=nearest";
		System.out.println(mongoURI);
		MongoDatabase mongodb = MongoClients.create(mongoURI).getDatabase(mongo_database);
		System.out.println(mongoURI);
		moveCol = mongodb.getCollection(mongo_move_collection);
		tempCol = mongodb.getCollection(mongo_temp_collection);
		logCol = mongodb.getCollection(mongo_error_collection);
	}

	public int getNumExpFromMongo() {
		try {
			// List<Document> results = new ArrayList<>();
			// moveCol.find().sort( descending("IdExperiencia")).into(results);
			FindIterable<Document> iterDoc = moveCol.find().sort(descending("numExp"));
			int moveNumExp;
			int tempNumExp;
			if (iterDoc.first() == null)
				moveNumExp = 0;
			else
				moveNumExp = iterDoc.first().getInteger("numExp");

			iterDoc = tempCol.find().sort(descending("numExp"));
			if (iterDoc.first() == null)
				tempNumExp = 0;
			else
				tempNumExp = iterDoc.first().getInteger("numExp");
			return (moveNumExp > tempNumExp) ? moveNumExp : tempNumExp;
			// return 1;
			/*
			 * for (Document document : iterDoc) {
			 * System.out.println(document.getString("Hora"));
			 * }
			 */
		} catch (java.lang.NullPointerException e) {
			return 0;
		}
	}

	public void increaseNumExp() {
		lock.lock();
		this.numExp++;
		lock.unlock();
	}

	public int getNumExp() {
		lock.lock();
		int id = this.numExp;
		lock.unlock();
		return id;
	}

	/*
	 * public void addToMazeManagementCollection() { //continue
	 * DBObject toInsert = (DBObject) JSON.parse("{Hora: '" + Utils.getCurrentDate()
	 * + "', IdExperiencia: " + idExperience + ", IdExperienciaSQL: -1}");
	 * System.out.println(toInsert);
	 * Document d = new Document();
	 * SimpleDateFormat formatter = new
	 * SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
	 * String date = formatter.format(Utils.getCurrentDate());
	 * System.out.println(date);
	 * d.append("Hora", date);
	 * d.append("IdExperiencia", idExperience);
	 * d.append("IdExperienciaSQL", -1);
	 * System.out.println(d);
	 * mazeCol.insertOne(d);
	 * }
	 */

	public static void main(String[] args) {
		CloudToMongo.getInstance();
		(new SendMovCloud()).start();
		(new SendTempCloud()).start();
	}
}