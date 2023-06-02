import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import static java.lang.Thread.sleep;

public class Main {

    public static void main(String[] args) throws InterruptedException {

        String user = "javaop";
        String password = "javaop";
        String address = "46.189.143.63:37140,3.8.243.72:37141";
        String database = "teste";
        String URI = "mongodb://"+user+":"+password+"@"+address+"/?&authSource="+database;

        MongoDatabase mongodb = MongoClients.create(URI).getDatabase(database);
        MongoCollection<Document> hashed = mongodb.getCollection("hashed");
        MongoCollection<Document> ranged = mongodb.getCollection("ranged");
        int i = 1;

        while(true){
            int cicle = i%9 +1;
            ranged.insertOne((new Document()).append("numExp", cicle).append("sequence",i));
            hashed.insertOne((new Document()).append("numExp", i));
            System.out.println("Sequence: "+i++);
            sleep(500);
        }
    }
}
