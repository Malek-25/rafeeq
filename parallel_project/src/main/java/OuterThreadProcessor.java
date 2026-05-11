import java.io.File;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.DoubleAdder;

/**
 * OUTER THREADING implementation.
 * Uses explicit Thread subclasses (extends Thread).
 * Files are divided into chunks - each thread processes its chunk.
 */
public class OuterThreadProcessor {

    // Thread-safe counters for aggregation across threads
    private static final AtomicLong totalRecords = new AtomicLong();
    private static final DoubleAdder totalScore = new DoubleAdder();
    private static final AtomicInteger premiumOrders = new AtomicInteger();

    /**
     * Simple processing with outer threads.
     */
    public static long runSimple(File[] files, int threadCount) throws InterruptedException {
        totalRecords.set(0);
        DoubleAdder maxAmount = new DoubleAdder();
        maxAmount.add(Double.MIN_VALUE);

        Thread[] threads = new Thread[threadCount];
        int chunkSize = (int) Math.ceil((double) files.length / threadCount);

        for (int i = 0; i < threadCount; i++) {
            final int start = i * chunkSize;
            final int end = Math.min(start + chunkSize, files.length);
            if (start >= files.length) {
                threads[i] = new Thread(() -> {}); // empty thread
                continue;
            }

            threads[i] = new SimpleWorker(files, start, end);
            threads[i].start();
        }

        for (Thread t : threads) t.join();
        return totalRecords.get();
    }

    /**
     * Complex processing with outer threads.
     */
    public static double runComplex(File[] files, int threadCount) throws InterruptedException {
        totalScore.reset();
        premiumOrders.set(0);

        Thread[] threads = new Thread[threadCount];
        int chunkSize = (int) Math.ceil((double) files.length / threadCount);

        for (int i = 0; i < threadCount; i++) {
            final int start = i * chunkSize;
            final int end = Math.min(start + chunkSize, files.length);
            if (start >= files.length) {
                threads[i] = new Thread(() -> {});
                continue;
            }

            threads[i] = new ComplexWorker(files, start, end);
            threads[i].start();
        }

        for (Thread t : threads) t.join();
        return totalScore.sum();
    }

    // ----- Worker Threads (extends Thread) -----

    static class SimpleWorker extends Thread {
        private final File[] files;
        private final int start, end;

        public SimpleWorker(File[] files, int start, int end) {
            this.files = files;
            this.start = start;
            this.end = end;
        }

        @Override
        public void run() {
            long localCount = 0;
            for (int i = start; i < end; i++) {
                List<Order> orders = DataReader.readFile(files[i]);
                localCount += orders.size();
            }
            totalRecords.addAndGet(localCount);
        }
    }

    static class ComplexWorker extends Thread {
        private final File[] files;
        private final int start, end;

        public ComplexWorker(File[] files, int start, int end) {
            this.files = files;
            this.start = start;
            this.end = end;
        }

        @Override
        public void run() {
            double localScore = 0;
            int localPremium = 0;
            for (int i = start; i < end; i++) {
                List<Order> orders = DataReader.readFile(files[i]);
                for (Order o : orders) {
                    double score = 0.4 * o.getAmount()
                                 + 0.3 * (60 - o.getDeliveryTime())
                                 + 0.3 * (o.getRestaurantId() % 10);
                    localScore += score;
                    if (o.getCity().equalsIgnoreCase("Amman")
                            && o.getAmount() > 20
                            && o.getDeliveryTime() <= 30) {
                        localPremium++;
                    }
                }
            }
            totalScore.add(localScore);
            premiumOrders.addAndGet(localPremium);
        }
    }
}
