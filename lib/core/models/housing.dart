class Housing {
  final String id;
  final String title;
  final String description;
  final double pricePerMonth;
  final double latitude;
  final double longitude;
  final double distanceFromUni;
  final String providerId;
  final String providerName;
  final List<String> imagePaths;
  final DateTime createdAt;
  final bool isActive;
  final int rating;
  final String? genderPreference; // 'M' for Male, 'F' for Female, null for both

  Housing({
    required this.id,
    required this.title,
    required this.description,
    required this.pricePerMonth,
    required this.latitude,
    required this.longitude,
    required this.distanceFromUni,
    required this.providerId,
    required this.providerName,
    this.imagePaths = const [],
    required this.createdAt,
    this.isActive = true,
    this.rating = 0,
    this.genderPreference,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pricePerMonth': pricePerMonth,
      'latitude': latitude,
      'longitude': longitude,
      'distanceFromUni': distanceFromUni,
      'providerId': providerId,
      'providerName': providerName,
      'imagePaths': imagePaths,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'rating': rating,
      'genderPreference': genderPreference,
    };
  }

  factory Housing.fromMap(Map<String, dynamic> map) {
    return Housing(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pricePerMonth: (map['pricePerMonth'] ?? 0.0).toDouble(),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      distanceFromUni: (map['distanceFromUni'] ?? 0.0).toDouble(),
      providerId: map['providerId'] ?? '',
      providerName: map['providerName'] ?? '',
      imagePaths: List<String>.from(map['imagePaths'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: map['isActive'] ?? true,
      rating: map['rating'] ?? 0,
      genderPreference: map['genderPreference'],
    );
  }

  Housing copyWith({
    String? id,
    String? title,
    String? description,
    double? pricePerMonth,
    double? latitude,
    double? longitude,
    double? distanceFromUni,
    String? providerId,
    String? providerName,
    List<String>? imagePaths,
    DateTime? createdAt,
    bool? isActive,
    int? rating,
    String? genderPreference,
  }) {
    return Housing(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceFromUni: distanceFromUni ?? this.distanceFromUni,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      genderPreference: genderPreference ?? this.genderPreference,
    );
  }
}