/**
 * Data model representing a single Talabat order row.
 */
public class Order {
    private final long orderId;
    private final long customerId;
    private final int restaurantId;
    private final String city;
    private final double amount;
    private final int deliveryTime;

    public Order(long orderId, long customerId, int restaurantId,
                 String city, double amount, int deliveryTime) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.restaurantId = restaurantId;
        this.city = city;
        this.amount = amount;
        this.deliveryTime = deliveryTime;
    }

    public long getOrderId() { return orderId; }
    public long getCustomerId() { return customerId; }
    public int getRestaurantId() { return restaurantId; }
    public String getCity() { return city; }
    public double getAmount() { return amount; }
    public int getDeliveryTime() { return deliveryTime; }
}
