import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;


public class Utils {

	public static Date getCurrentDate() {
		Date currDate = null;
		try {
			URL url = new URL("http://worldtimeapi.org/api/timezone/Europe/Lisbon");
			DBObject document_json;
			document_json = BasicDBObject.parse(stream(url));
			String aux = (String) document_json.get("datetime");
			String currentDate = aux.split("\\+")[0].replace("T", " ");
			currDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(currentDate);
		} catch (IOException | ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return currDate;
	}

	public static String stream(URL url) throws IOException {
		try (InputStream input = url.openStream()) {
			InputStreamReader isr = new InputStreamReader(input);
			BufferedReader reader = new BufferedReader(isr);
			StringBuilder json = new StringBuilder();
			int c;
			while ((c = reader.read()) != -1) {
				json.append((char) c);
			}
			return json.toString();
		}
	}

	/*
	 * public boolean isNewer(Date recent, Date last) {
	 * if(last==null) {
	 * return checkIfTimeIsRecent(recent, getCurrentDate());
	 * }
	 * if(recent.compareTo(last) < 0) return false;
	 * if(checkIfTimeIsRecent(recent, last)) return true;
	 * if(checkIfTimeIsRecent(recent, getCurrentDate())) return true;
	 * return false;
	 * }
	 * 
	 * public boolean checkIfTimeIsRecent(Date recent, Date toCompare) {
	 * long curTimeInMs = toCompare.getTime();
	 * Date maxDate = new Date(curTimeInMs + (this.minutesRange*
	 * ONE_MINUTE_IN_MILLIS));
	 * Date minDate = new Date(curTimeInMs - (this.minutesRange*
	 * ONE_MINUTE_IN_MILLIS));
	 * return (maxDate.compareTo(recent) >= 0 && recent.compareTo(minDate) >= 0);
	 * 
	 * }
	 */

}
