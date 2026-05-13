// This class represents one order from the dataset
public class Order {
    public long orderId;
    public long customerId;
    public int restaurantId;
    public String city;
    public double amount;
    public int deliveryTime;

    public Order(long orderId, long customerId, int restaurantId,
                 String city, double amount, int deliveryTime) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.restaurantId = restaurantId;
        this.city = city;
        this.amount = amount;
        this.deliveryTime = deliveryTime;
    }
}
