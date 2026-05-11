import java.io.File;

/**
 * Main entry point.
 * Runs all benchmarks: Sequential (simple + complex), Outer Threads, Inner Threads
 * for thread counts: 2, 4, 8, 16, 32, 64, 128
 */
public class Main {

    private static final String DATASET_DIR = "dataset";
    private static final String RESULTS_FILE = "results/performance_results.csv";
    private static final int[] THREAD_COUNTS = {2, 4, 8, 16, 32, 64, 128};

    public static void main(String[] args) throws Exception {
        System.out.println("========================================");
        System.out.println(" PARALLEL PROGRAMMING - PHASE 2");
        System.out.println(" Talabat Orders Dataset Analysis");
        System.out.println("========================================\n");

        File[] files = DataReader.listXlsxFiles(DATASET_DIR);
        System.out.println("Found " + files.length + " .xlsx files in dataset/\n");

        PerformanceLogger logger = new PerformanceLogger(RESULTS_FILE);
        logger.init();

        // =========== SEQUENTIAL ===========
        System.out.println("--- SEQUENTIAL PROCESSING ---");
        long startSimple = System.currentTimeMillis();
        SequentialProcessor.SimpleResult simpleRes = SequentialProcessor.processSimple(files);
        long simpleTime = System.currentTimeMillis() - startSimple;
        System.out.println("Simple:  " + simpleTime + " ms  | Total records: " + simpleRes.totalRecords
                + ", Max: " + simpleRes.maxAmount + ", Min: " + simpleRes.minAmount);
        logger.log("Sequential", "Simple", 1, simpleTime);

        long startComplex = System.currentTimeMillis();
        SequentialProcessor.ComplexResult complexRes = SequentialProcessor.processComplex(files);
        long complexTime = System.currentTimeMillis() - startComplex;
        System.out.println("Complex: " + complexTime + " ms  | Premium orders: " + complexRes.premiumOrders
                + ", Total score: " + String.format("%.2f", complexRes.totalWeightedScore));
        logger.log("Sequential", "Complex", 1, complexTime);
        System.out.println();

        // =========== OUTER THREADING ===========
        System.out.println("--- OUTER THREADING (extends Thread) ---");
        for (int n : THREAD_COUNTS) {
            long t1 = System.currentTimeMillis();
            OuterThreadProcessor.runSimple(files, n);
            long outSimple = System.currentTimeMillis() - t1;
            logger.log("OuterThread", "Simple", n, outSimple);

            long t2 = System.currentTimeMillis();
            OuterThreadProcessor.runComplex(files, n);
            long outComplex = System.currentTimeMillis() - t2;
            logger.log("OuterThread", "Complex", n, outComplex);

            System.out.printf("Threads=%3d  | Simple: %5d ms  | Complex: %5d ms%n",
                    n, outSimple, outComplex);
        }
        System.out.println();

        // =========== INNER THREADING ===========
        System.out.println("--- INNER THREADING (lambda / Runnable) ---");
        for (int n : THREAD_COUNTS) {
            long t1 = System.currentTimeMillis();
            InnerThreadProcessor.runSimple(files, n);
            long inSimple = System.currentTimeMillis() - t1;
            logger.log("InnerThread", "Simple", n, inSimple);

            long t2 = System.currentTimeMillis();
            InnerThreadProcessor.runComplex(files, n);
            long inComplex = System.currentTimeMillis() - t2;
            logger.log("InnerThread", "Complex", n, inComplex);

            System.out.printf("Threads=%3d  | Simple: %5d ms  | Complex: %5d ms%n",
                    n, inSimple, inComplex);
        }

        logger.close();
        System.out.println("\n========================================");
        System.out.println(" DONE! Results saved to " + RESULTS_FILE);
        System.out.println("========================================");
    }
}
