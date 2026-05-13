import java.io.File;

// Main class - runs all tests and records execution times
public class Main {

    public static void main(String[] args) throws Exception {

        // Path to dataset folder - CHANGE THIS TO YOUR FOLDER
        String datasetPath = "dataset";

        // Thread counts to test
        int[] threadCounts = {2, 4, 8, 16, 32, 64, 128};

        System.out.println("========================================");
        System.out.println(" PARALLEL PROGRAMMING - PHASE 2");
        System.out.println(" Talabat Orders Dataset");
        System.out.println("========================================");

        // Read all files
        File[] files = DataReader.getFiles(datasetPath);
        System.out.println("Files found: " + files.length);
        System.out.println();

        // WARM UP: read all files once so disk cache is warm for both tests
        System.out.println("Loading files into cache...");
        for (File f : files) { DataReader.readFile(f); }
        System.out.println("Cache ready.\n");

        // Create logger
        PerformanceLogger logger = new PerformanceLogger("results/performance_results.csv");

        // ============ SEQUENTIAL PROCESSING ============
        System.out.println("--- SEQUENTIAL PROCESSING ---");

        // Simple
        long start = System.currentTimeMillis();
        SequentialProcessor.processSimple(files);
        long simpleTime = System.currentTimeMillis() - start;
        System.out.println("  Time: " + simpleTime + " ms");
        logger.log("Sequential", "Simple", 1, simpleTime);
        System.out.println();

        // Complex
        start = System.currentTimeMillis();
        SequentialProcessor.processComplex(files);
        long complexTime = System.currentTimeMillis() - start;
        System.out.println("  Time: " + complexTime + " ms");
        logger.log("Sequential", "Complex", 1, complexTime);
        System.out.println();

        // ============ OUTER THREADING ============
        System.out.println("--- OUTER THREADING (extends Thread) ---");
        for (int n : threadCounts) {
            start = System.currentTimeMillis();
            OuterThreadProcessor.runSimple(files, n);
            long t1 = System.currentTimeMillis() - start;
            logger.log("OuterThread", "Simple", n, t1);

            start = System.currentTimeMillis();
            OuterThreadProcessor.runComplex(files, n);
            long t2 = System.currentTimeMillis() - start;
            logger.log("OuterThread", "Complex", n, t2);

            System.out.println("Threads=" + n + "  | Simple: " + t1 + " ms | Complex: " + t2 + " ms");
        }
        System.out.println();

        // ============ INNER THREADING ============
        System.out.println("--- INNER THREADING (lambda / Runnable) ---");
        for (int n : threadCounts) {
            start = System.currentTimeMillis();
            InnerThreadProcessor.runSimple(files, n);
            long t1 = System.currentTimeMillis() - start;
            logger.log("InnerThread", "Simple", n, t1);

            start = System.currentTimeMillis();
            InnerThreadProcessor.runComplex(files, n);
            long t2 = System.currentTimeMillis() - start;
            logger.log("InnerThread", "Complex", n, t2);

            System.out.println("Threads=" + n + "  | Simple: " + t1 + " ms | Complex: " + t2 + " ms");
        }

        logger.close();
        System.out.println();
        System.out.println("========================================");
        System.out.println(" DONE! Results saved to results/performance_results.csv");
        System.out.println("========================================");
    }
}
