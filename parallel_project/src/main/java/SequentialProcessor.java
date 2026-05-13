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

    // COMPLEX PROCESSING: per-day analytics + per-minute efficiency
    public static void processComplex(File[] files) {
        double totalScore = 0;
        int premiumOrders = 0;
        double bestDayRevenue = 0;
        String bestDayFile = "";
        double totalHoursAmman = 0;
        double totalHoursIrbid = 0;

        for (File file : files) {
            ArrayList<Order> orders = DataReader.readFile(file);

            double dayRevenueAmman = 0;
            double dayRevenueIrbid = 0;
            int dayTimeAmman = 0;
            int dayTimeIrbid = 0;

            for (Order o : orders) {
                // Per-minute efficiency analysis
                double orderScore = 0;
                for (int minute = 1; minute <= o.deliveryTime; minute++) {
                    orderScore += o.amount / minute;
                    orderScore += (o.deliveryTime - minute) * o.amount / o.deliveryTime;
                }

                // Additional calculations
                double costPerMinute = o.amount / o.deliveryTime;
                double efficiency = (o.amount * o.amount) / (o.deliveryTime + 1);
                double rating = (orderScore + costPerMinute + efficiency) / 3.0;
                totalScore += rating;

                // Multi-condition filtering
                if (o.city.equals("Amman") && o.amount > 20 && o.deliveryTime <= 30) {
                    premiumOrders++;
                }
                if (o.city.equals("Irbid") && o.amount > 15 && o.deliveryTime <= 45) {
                    premiumOrders++;
                }

                // Grouping per city per day
                if (o.city.equals("Amman")) {
                    dayRevenueAmman += o.amount;
                    dayTimeAmman += o.deliveryTime;
                } else {
                    dayRevenueIrbid += o.amount;
                    dayTimeIrbid += o.deliveryTime;
                }
            }

            // Convert minutes to hours per day
            totalHoursAmman += dayTimeAmman / 60.0;
            totalHoursIrbid += dayTimeIrbid / 60.0;

            // Find best day (highest revenue)
            double dayTotal = dayRevenueAmman + dayRevenueIrbid;
            if (dayTotal > bestDayRevenue) {
                bestDayRevenue = dayTotal;
                bestDayFile = file.getName();
            }
        }

        System.out.println("  [Complex] Total Score: " + totalScore);
        System.out.println("  [Complex] Premium Orders: " + premiumOrders);
        System.out.println("  [Complex] Working Hours Amman: " + totalHoursAmman);
        System.out.println("  [Complex] Working Hours Irbid: " + totalHoursIrbid);
        System.out.println("  [Complex] Best Day: " + bestDayFile + " (" + bestDayRevenue + " JOD)");
        System.out.println("  [Complex] Total Days: " + files.length);
    }
}
