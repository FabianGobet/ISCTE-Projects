import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class Direto {

    private Connection conn;
    private List<String> calls;
    private List<String> inserts;
    private Long ti, tf;

   public Direto(Connection conn, List<String> calls, List<String> inserts){
       this.conn=conn;
       this.calls=calls;
       this.inserts=inserts;
   }

   public List<Long> runTest(){
       ti = System.nanoTime();
       doStuff();
       tf = System.nanoTime();
       return new ArrayList<Long>(Arrays.asList(ti,tf,tf-ti));
   }


    public void doStuff() {
        for (String cmd : inserts) {
            try {
                 conn.prepareStatement(cmd).execute();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        for (String cmd : calls) {
            try {
                conn.prepareCall(cmd).execute();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

    }


}
