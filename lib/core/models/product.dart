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
  final DateTime timestamp; // Added for Firestore ordering

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
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'condition': condition,
      'sellerName': sellerName,
      'sellerEmail': sellerEmail,
      'sellerPhone': sellerPhone,
      'sellerRating': sellerRating,
      'location': location,
      'images': images,
      'description': description,
      'negotiable': negotiable,
      'timestamp': timestamp.millisecondsSinceEpoch, // Firestore timestamp
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    // Handle price conversion - it might be int or double
    double priceValue;
    if (map['price'] == null) {
      priceValue = 0.0;
    } else if (map['price'] is int) {
      priceValue = (map['price'] as int).toDouble();
    } else if (map['price'] is double) {
      priceValue = map['price'] as double;
    } else {
      priceValue = double.tryParse(map['price'].toString()) ?? 0.0;
    }
    
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      price: priceValue,
      condition: map['condition'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerEmail: map['sellerEmail'] ?? '',
      sellerPhone: map['sellerPhone'] ?? '',
      sellerRating: (map['sellerRating'] ?? 5.0).toDouble(),
      location: map['location'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      description: map['description'] ?? '',
      negotiable: map['negotiable'] ?? false,
      timestamp: map['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : DateTime.now(),
    );
  }
}
