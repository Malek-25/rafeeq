import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Sequential (single-thread) processing implementations.
 * Provides both Simple and Complex processing methods.
 */
public class SequentialProcessor {

    /**
     * SIMPLE PROCESSING
     * - Counts total records
     * - Finds max and min order amount
     * - Counts orders per city
     */
    public static SimpleResult processSimple(File[] files) {
        long totalRecords = 0;
        double maxAmount = Double.MIN_VALUE;
        double minAmount = Double.MAX_VALUE;
        Map<String, Integer> cityCounts = new HashMap<>();

        for (File file : files) {
            List<Order> orders = DataReader.readFile(file);
            for (Order o : orders) {
                totalRecords++;
                if (o.getAmount() > maxAmount) maxAmount = o.getAmount();
                if (o.getAmount() < minAmount) minAmount = o.getAmount();
                cityCounts.merge(o.getCity(), 1, Integer::sum);
            }
        }

        return new SimpleResult(totalRecords, maxAmount, minAmount, cityCounts);
    }

    /**
     * COMPLEX PROCESSING
     * - Computes weighted customer score for each order
     *   score = 0.4 * amount + 0.3 * (60 - deliveryTime) + 0.3 * restaurantId%10
     * - Multi-condition filtering (Amman orders over JD 20 with delivery <= 30min)
     * - Aggregates total amount per city
     */
    public static ComplexResult processComplex(File[] files) {
        double totalWeightedScore = 0;
        int premiumOrders = 0;
        Map<String, Double> revenuePerCity = new HashMap<>();
        Map<String, Integer> ordersPerCity = new HashMap<>();

        for (File file : files) {
            List<Order> orders = DataReader.readFile(file);
            for (Order o : orders) {
                // Weighted score calculation (floating-point heavy)
                double score = 0.4 * o.getAmount()
                             + 0.3 * (60 - o.getDeliveryTime())
                             + 0.3 * (o.getRestaurantId() % 10);
                totalWeightedScore += score;

                // Multi-condition filter
                if (o.getCity().equalsIgnoreCase("Amman")
                        && o.getAmount() > 20
                        && o.getDeliveryTime() <= 30) {
                    premiumOrders++;
                }

                // Aggregation per city
                revenuePerCity.merge(o.getCity(), o.getAmount(), Double::sum);
                ordersPerCity.merge(o.getCity(), 1, Integer::sum);
            }
        }

        // Average order amount per city (more floating-point ops)
        Map<String, Double> avgPerCity = new HashMap<>();
        for (String city : revenuePerCity.keySet()) {
            avgPerCity.put(city, revenuePerCity.get(city) / ordersPerCity.get(city));
        }

        return new ComplexResult(totalWeightedScore, premiumOrders,
                revenuePerCity, avgPerCity);
    }

    // ----- Result wrapper classes -----

    public static class SimpleResult {
        public final long totalRecords;
        public final double maxAmount;
        public final double minAmount;
        public final Map<String, Integer> cityCounts;

        public SimpleResult(long totalRecords, double maxAmount, double minAmount,
                            Map<String, Integer> cityCounts) {
            this.totalRecords = totalRecords;
            this.maxAmount = maxAmount;
            this.minAmount = minAmount;
            this.cityCounts = cityCounts;
        }
    }

    public static class ComplexResult {
        public final double totalWeightedScore;
        public final int premiumOrders;
        public final Map<String, Double> revenuePerCity;
        public final Map<String, Double> avgPerCity;

        public ComplexResult(double totalWeightedScore, int premiumOrders,
                             Map<String, Double> revenuePerCity,
                             Map<String, Double> avgPerCity) {
            this.totalWeightedScore = totalWeightedScore;
            this.premiumOrders = premiumOrders;
            this.revenuePerCity = revenuePerCity;
            this.avgPerCity = avgPerCity;
        }
    }
}
