import java.io.File;
import java.util.ArrayList;

// Inner Threading - uses lambda and inner Runnable
public class InnerThreadProcessor {

    private static int totalRecords = 0;
    private static double totalScore = 0;
    private static int premiumOrders = 0;

    private static synchronized void addRecords(int count) { totalRecords += count; }
    private static synchronized void addScore(double score) { totalScore += score; }
    private static synchronized void addPremium(int count) { premiumOrders += count; }

    // ---- SIMPLE PROCESSING with inner threads (lambda) ----
    public static void runSimple(File[] files, int threadCount) throws InterruptedException {
        totalRecords = 0;
        Thread[] threads = new Thread[threadCount];
        int filesPerThread = files.length / threadCount;

        for (int i = 0; i < threadCount; i++) {
            final int start = i * filesPerThread;
            final int end = (i == threadCount - 1) ? files.length : start + filesPerThread;

            // Lambda expression - inner thread
            threads[i] = new Thread(() -> {
                int localCount = 0;
                for (int f = start; f < end; f++) {
                    ArrayList<Order> orders = DataReader.readFile(files[f]);
                    localCount += orders.size();
                }
                addRecords(localCount);
            });
            threads[i].start();
        }
        for (int i = 0; i < threadCount; i++) { threads[i].join(); }
    }

    // ---- COMPLEX PROCESSING with inner threads (inner Runnable) ----
    public static void runComplex(File[] files, int threadCount) throws InterruptedException {
        totalScore = 0;
        premiumOrders = 0;
        Thread[] threads = new Thread[threadCount];
        int filesPerThread = files.length / threadCount;

        for (int i = 0; i < threadCount; i++) {
            final int start = i * filesPerThread;
            final int end = (i == threadCount - 1) ? files.length : start + filesPerThread;

            // Inner Runnable class
            Runnable task = new Runnable() {
                @Override
                public void run() {
                    double localScore = 0;
                    int localPremium = 0;

                    for (int f = start; f < end; f++) {
                        ArrayList<Order> orders = DataReader.readFile(files[f]);
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
            };

            threads[i] = new Thread(task);
            threads[i].start();
        }
        for (int i = 0; i < threadCount; i++) { threads[i].join(); }
    }
}
