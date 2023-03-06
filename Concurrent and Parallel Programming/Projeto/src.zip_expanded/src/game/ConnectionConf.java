package game;

import java.io.IOException;

interface ConnectionConf {
    public final int PORT = 4321;
    public void connect() throws IOException;
}
