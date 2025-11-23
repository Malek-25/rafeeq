class Service {
  final String id;
  final String name;
  final String description;
  final double pricePerUnit;
  final String unit; // 'item', 'visit', 'piece'
  final String category; // 'laundry', 'cleaning', 'other'
  final String providerId;
  final String providerName;
  final String? imagePath;
  final DateTime createdAt;
  final bool isActive;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerUnit,
    required this.unit,
    required this.category,
    required this.providerId,
    required this.providerName,
    this.imagePath,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pricePerUnit': pricePerUnit,
      'unit': unit,
      'category': category,
      'providerId': providerId,
      'providerName': providerName,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      pricePerUnit: (map['pricePerUnit'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'item',
      category: map['category'] ?? 'other',
      providerId: map['providerId'] ?? '',
      providerName: map['providerName'] ?? '',
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: map['isActive'] ?? true,
    );
  }

  Service copyWith({
    String? id,
    String? name,
    String? description,
    double? pricePerUnit,
    String? unit,
    String? category,
    String? providerId,
    String? providerName,
    String? imagePath,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

