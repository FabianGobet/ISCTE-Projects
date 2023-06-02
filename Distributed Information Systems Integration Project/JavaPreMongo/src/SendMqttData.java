
public class SendMqttData {

    public static void main(String[] args) {

        (new SendMovCloud()).start();
        (new SendTempCloud()).start();

    }

}
