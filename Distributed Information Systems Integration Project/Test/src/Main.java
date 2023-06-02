import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;

public class Main {

    public Connection sqlConn;
    public void connect(){
        Properties p = new Properties();

        try {
            p.load(new FileInputStream("lib/sqlserver.properties"));
        } catch (IOException e) {
            throw new RuntimeException(e);
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

    public static void main(String[] args) {
        Main m = new Main();
        m.connect();
        Generator g = new Generator();
        g.generateCommands();
        System.out.println("Comandos gerados: "+Generator.NUM_COMMANDS*3+" comandos.");
        Direto direto = new Direto(m.sqlConn,g.calls,g.inserts);
        Indireto indireto = new Indireto(m.sqlConn,g.calls,g.inserts);

        List<Long> diretoTiming = direto.runTest();
        System.out.println("Tempo para direto: "+diretoTiming.get(2)/Math.pow(10,9));
        List<Long> indiretoTiming = indireto.runTest();
        System.out.println("Tempo para indireto (Sem QOS): = "+indiretoTiming.get(2)/Math.pow(10,9));


    }
}
