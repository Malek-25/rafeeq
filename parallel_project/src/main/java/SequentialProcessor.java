import java.io.File;
import java.util.ArrayList;

// Sequential processing - runs on a single thread
public class SequentialProcessor {

    // SIMPLE PROCESSING: count records, find max/min, count per city
    public static void processSimple(File[] files) {
        int totalRecords = 0;
        double maxAmount = 0;
        double minAmount = Double.MAX_VALUE;
        int ammanCount = 0;
        int irbidCount = 0;

        for (File file : files) {
            ArrayList<Order> orders = DataReader.readFile(file);
            for (Order o : orders) {
                totalRecords++;
                if (o.amount > maxAmount) maxAmount = o.amount;
                if (o.amount < minAmount) minAmount = o.amount;
                if (o.city.equals("Amman")) ammanCount++;
                if (o.city.equals("Irbid")) irbidCount++;
            }
        }

        System.out.println("  [Simple] Total Records: " + totalRecords);
        System.out.println("  [Simple] Max Amount: " + maxAmount);
        System.out.println("  [Simple] Min Amount: " + minAmount);
        System.out.println("  [Simple] Amman Orders: " + ammanCount);
        System.out.println("  [Simple] Irbid Orders: " + irbidCount);
    }

    // COMPLEX PROCESSING: heavy math + filtering + aggregation
    public static void processComplex(File[] files) {
        double totalScore = 0;
        int premiumOrders = 0;
        double ammanRevenue = 0;
        double irbidRevenue = 0;

        for (File file : files) {
            ArrayList<Order> orders = DataReader.readFile(file);
            for (Order o : orders) {

                // Heavy floating-point computation (repeated to increase CPU load)
                double score = 0;
                for (int k = 0; k < 500; k++) {
                    score += Math.sin(o.amount * k) * Math.cos(o.deliveryTime * k);
                    score += Math.sqrt(o.amount * o.deliveryTime + k);
                    score += Math.log(o.amount + k + 1) * Math.pow(o.deliveryTime, 0.3);
                }

                // Weighted score
                score += 0.4 * o.amount + 0.3 * (60 - o.deliveryTime) + 0.3 * (o.restaurantId % 10);
                totalScore += score;

                // Multi-condition filtering
                if (o.city.equals("Amman") && o.amount > 20 && o.deliveryTime <= 30) {
                    premiumOrders++;
                }
                if (o.city.equals("Irbid") && o.amount > 15 && o.deliveryTime <= 45) {
                    premiumOrders++;
                }

                // Aggregation per city
                if (o.city.equals("Amman")) ammanRevenue += o.amount;
                if (o.city.equals("Irbid")) irbidRevenue += o.amount;
            }
        }

        System.out.println("  [Complex] Total Weighted Score: " + totalScore);
        System.out.println("  [Complex] Premium Orders: " + premiumOrders);
        System.out.println("  [Complex] Amman Total Revenue: " + ammanRevenue);
        System.out.println("  [Complex] Irbid Total Revenue: " + irbidRevenue);
    }
}
