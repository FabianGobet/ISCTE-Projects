import java.util.ArrayList;
import java.util.List;
import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;
public class Generator {

    public final static int NUM_COMMANDS=10;
    DateTimeFormatter dtf;
    public List<String> inserts = new ArrayList<>();
    public List<String> calls = new ArrayList<>();
    public Generator(){
        this.dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    }


    public void generateCommands(){

        for(int i = 11; i<NUM_COMMANDS+11; i++){
            generateLog(i);
            generateCall(i);
        }

    }

    private void generateLog(int num){
        inserts.add("INSERT INTO log(DataHora, Tipo, Valor) VALUES(\"" + dtf.format(LocalDateTime.now()) + "\", \"Dado corrompido\",\"Log: " + num + "\")");
    }

    private void generateCall(int num){
        calls.add("call introduzirErroExperiencia(1,\"" + dtf.format(LocalDateTime.now()) + "\",\"" + "SalaEntrada:"+(num)+",SalaSaida: 1\")");
        calls.add("call introduzirPassagem(1,2,1,\"" + dtf.format(LocalDateTime.now()) + "\")");
    }

}
