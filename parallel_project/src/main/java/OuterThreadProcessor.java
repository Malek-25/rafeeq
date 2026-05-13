import java.io.File;
import java.util.ArrayList;

// Outer Threading - uses extends Thread
public class OuterThreadProcessor {

    private static int totalRecords = 0;
    private static double totalScore = 0;
    private static int premiumOrders = 0;

    private static synchronized void addRecords(int count) { totalRecords += count; }
    private static synchronized void addScore(double score) { totalScore += score; }
    private static synchronized void addPremium(int count) { premiumOrders += count; }

    // ---- SIMPLE PROCESSING with outer threads ----
    public static void runSimple(File[] files, int threadCount) throws InterruptedException {
        totalRecords = 0;
        Thread[] threads = new Thread[threadCount];
        int filesPerThread = files.length / threadCount;

        for (int i = 0; i < threadCount; i++) {
            int start = i * filesPerThread;
            int end = (i == threadCount - 1) ? files.length : start + filesPerThread;
            threads[i] = new SimpleWorkerThread(files, start, end);
            threads[i].start();
        }
        for (int i = 0; i < threadCount; i++) { threads[i].join(); }
    }

    // ---- COMPLEX PROCESSING with outer threads ----
    public static void runComplex(File[] files, int threadCount) throws InterruptedException {
        totalScore = 0;
        premiumOrders = 0;
        Thread[] threads = new Thread[threadCount];
        int filesPerThread = files.length / threadCount;

        for (int i = 0; i < threadCount; i++) {
            int start = i * filesPerThread;
            int end = (i == threadCount - 1) ? files.length : start + filesPerThread;
            threads[i] = new ComplexWorkerThread(files, start, end);
            threads[i].start();
        }
        for (int i = 0; i < threadCount; i++) { threads[i].join(); }
    }

    // Simple worker - extends Thread
    static class SimpleWorkerThread extends Thread {
        private File[] files;
        private int start, end;

        public SimpleWorkerThread(File[] files, int start, int end) {
            this.files = files; this.start = start; this.end = end;
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

    // Complex worker - extends Thread
    static class ComplexWorkerThread extends Thread {
        private File[] files;
        private int start, end;

        public ComplexWorkerThread(File[] files, int start, int end) {
            this.files = files; this.start = start; this.end = end;
        }

        @Override
        public void run() {
            double localScore = 0;
            int localPremium = 0;

            for (int i = start; i < end; i++) {
                ArrayList<Order> orders = DataReader.readFile(files[i]);
                for (Order o : orders) {
                    // Per-minute efficiency analysis
                    double orderScore = 0;
                    for (int minute = 1; minute <= o.deliveryTime; minute++) {
                        orderScore += o.amount / minute;
                        orderScore += (o.deliveryTime - minute) * o.amount / o.deliveryTime;
                    }

                    double costPerMinute = o.amount / o.deliveryTime;
                    double efficiency = (o.amount * o.amount) / (o.deliveryTime + 1);
                    double rating = (orderScore + costPerMinute + efficiency) / 3.0;
                    localScore += rating;

                    if (o.city.equals("Amman") && o.amount > 20 && o.deliveryTime <= 30) {
                        localPremium++;
                    }
                    if (o.city.equals("Irbid") && o.amount > 15 && o.deliveryTime <= 45) {
                        localPremium++;
                    }
                }
            }
            addScore(localScore);
            addPremium(localPremium);
        }
    }
}
