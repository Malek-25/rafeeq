import java.io.FileWriter;
import java.io.File;

// Simple class to save results to a CSV file
public class PerformanceLogger {

    private FileWriter writer;

    public PerformanceLogger(String filePath) {
        try {
            new File("results").mkdir();
            writer = new FileWriter(filePath);
            writer.write("Mode,Processing,Threads,TimeMs\n");
        } catch (Exception e) {
            System.out.println("Error creating log file: " + e.getMessage());
        }
    }

    public void log(String mode, String processing, int threads, long timeMs) {
        try {
            writer.write(mode + "," + processing + "," + threads + "," + timeMs + "\n");
            writer.flush();
        } catch (Exception e) {
            System.out.println("Error writing to log: " + e.getMessage());
        }
    }

    public void close() {
        try {
            writer.close();
        } catch (Exception e) {
            // ignore
        }
    }
}
