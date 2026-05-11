import java.io.File;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.DoubleAdder;

/**
 * INNER THREADING implementation.
 * Uses Runnable lambdas / inner Runnable classes instead of extending Thread.
 * Demonstrates the same work with a more compact/modern approach.
 */
public class InnerThreadProcessor {

    /**
     * Simple processing with inner (lambda) threads.
     */
    public static long runSimple(File[] files, int threadCount) throws InterruptedException {
        AtomicLong totalRecords = new AtomicLong(0);

        Thread[] threads = new Thread[threadCount];
        int chunkSize = (int) Math.ceil((double) files.length / threadCount);

        for (int i = 0; i < threadCount; i++) {
            final int start = i * chunkSize;
            final int end = Math.min(start + chunkSize, files.length);

            // Lambda Runnable - INNER threading style
            threads[i] = new Thread(() -> {
                if (start >= files.length) return;
                long localCount = 0;
                for (int f = start; f < end; f++) {
                    List<Order> orders = DataReader.readFile(files[f]);
                    localCount += orders.size();
                }
                totalRecords.addAndGet(localCount);
            });

            threads[i].start();
        }

        for (Thread t : threads) t.join();
        return totalRecords.get();
    }

    /**
     * Complex processing with inner (lambda) threads.
     */
    public static double runComplex(File[] files, int threadCount) throws InterruptedException {
        DoubleAdder totalScore = new DoubleAdder();
        AtomicInteger premiumOrders = new AtomicInteger(0);

        Thread[] threads = new Thread[threadCount];
        int chunkSize = (int) Math.ceil((double) files.length / threadCount);

        for (int i = 0; i < threadCount; i++) {
            final int start = i * chunkSize;
            final int end = Math.min(start + chunkSize, files.length);

            // Inner Runnable
            Runnable task = new Runnable() {
                @Override
                public void run() {
                    if (start >= files.length) return;
                    double localScore = 0;
                    int localPremium = 0;
                    for (int f = start; f < end; f++) {
                        List<Order> orders = DataReader.readFile(files[f]);
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
            };

            threads[i] = new Thread(task);
            threads[i].start();
        }

        for (Thread t : threads) t.join();
        return totalScore.sum();
    }
}
