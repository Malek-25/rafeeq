import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Writes benchmark results to a CSV file for easy import into Excel/Report.
 */
public class PerformanceLogger {

    private final String outputPath;
    private FileWriter writer;

    public PerformanceLogger(String outputPath) {
        this.outputPath = outputPath;
    }

    public void init() throws IOException {
        Files.createDirectories(Paths.get(outputPath).getParent());
        writer = new FileWriter(outputPath);
        writer.write("Mode,Processing,Threads,ExecutionTimeMs\n");
    }

    public synchronized void log(String mode, String processing, int threads, long millis) {
        try {
            writer.write(String.format("%s,%s,%d,%d%n", mode, processing, threads, millis));
            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void close() throws IOException {
        if (writer != null) writer.close();
    }
}
