class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final String condition;
  final String sellerName;
  final String sellerEmail;
  final String sellerPhone;
  final double sellerRating;
  final String location;
  final List<String> images;
  final String description;
  final bool negotiable;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.condition,
    required this.sellerName,
    required this.sellerEmail,
    required this.sellerPhone,
    required this.sellerRating,
    required this.location,
    required this.images,
    required this.description,
    this.negotiable = false,
  });
}
