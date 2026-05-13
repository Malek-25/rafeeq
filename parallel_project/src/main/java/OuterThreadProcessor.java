import java.io.File;
import java.util.ArrayList;

// Outer Threading - uses extends Thread
public class OuterThreadProcessor {

    // Shared variables (synchronized access)
    private static int totalRecords = 0;
    private static double totalScore = 0;
    private static int premiumOrders = 0;

    // Synchronized methods to safely update shared variables
    private static synchronized void addRecords(int count) {
        totalRecords += count;
    }

    private static synchronized void addScore(double score) {
        totalScore += score;
    }

    private static synchronized void addPremium(int count) {
        premiumOrders += count;
    }

    // ---- SIMPLE PROCESSING with outer threads ----
    public static void runSimple(File[] files, int threadCount) throws InterruptedException {
        totalRecords = 0;

        Thread[] threads = new Thread[threadCount];
        int filesPerThread = files.length / threadCount;

        for (int i = 0; i < threadCount; i++) {
            int start = i * filesPerThread;
            int end;
            if (i == threadCount - 1) {
                end = files.length; // last thread takes remaining
            } else {
                end = start + filesPerThread;
            }

            threads[i] = new SimpleWorkerThread(files, start, end);
            threads[i].start();
        }

        // Wait for all threads to finish
        for (int i = 0; i < threadCount; i++) {
            threads[i].join();
        }
    }

    // ---- COMPLEX PROCESSING with outer threads ----
    public static void runComplex(File[] files, int threadCount) throws InterruptedException {
        totalScore = 0;
        premiumOrders = 0;

        Thread[] threads = new Thread[threadCount];
        int filesPerThread = files.length / threadCount;

        for (int i = 0; i < threadCount; i++) {
            int start = i * filesPerThread;
            int end;
            if (i == threadCount - 1) {
                end = files.length;
            } else {
                end = start + filesPerThread;
            }

            threads[i] = new ComplexWorkerThread(files, start, end);
            threads[i].start();
        }

        for (int i = 0; i < threadCount; i++) {
            threads[i].join();
        }
    }

    // Worker thread for simple processing - extends Thread
    static class SimpleWorkerThread extends Thread {
        private File[] files;
        private int start;
        private int end;

        public SimpleWorkerThread(File[] files, int start, int end) {
            this.files = files;
            this.start = start;
            this.end = end;
        }

        @Override
        public void run() {
            int localCount = 0;
            for (int i = start; i < end; i++) {
                ArrayList<Order> orders = DataReader.readFile(files[i]);
                localCount += orders.size();
            }
            addRecords(localCount);
        }
    }

    // Worker thread for complex processing - extends Thread
    static class ComplexWorkerThread extends Thread {
        private File[] files;
        private int start;
        private int end;

        public ComplexWorkerThread(File[] files, int start, int end) {
            this.files = files;
            this.start = start;
            this.end = end;
        }

        @Override
        public void run() {
            double localScore = 0;
            int localPremium = 0;
            for (int i = start; i < end; i++) {
                ArrayList<Order> orders = DataReader.readFile(files[i]);
                for (Order o : orders) {
                    double score = 0.4 * o.amount + 0.3 * (60 - o.deliveryTime) + 0.3 * (o.restaurantId % 10);
                    localScore += score;
                    if (o.city.equals("Amman") && o.amount > 20 && o.deliveryTime <= 30) {
                        localPremium++;
                    }
                }
            }
            addScore(localScore);
            addPremium(localPremium);
        }
    }
}
