class Hotel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String country;
  final double? latitude;
  final double? longitude;
  final double pricePerNight;
  final double guestRating;
  final int totalReviews;
  final int starRating;
  final List<String> images;
  final List<String> amenities;
  final bool featured;
  final bool available;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.country,
    this.latitude,
    this.longitude,
    required this.pricePerNight,
    required this.guestRating,
    required this.totalReviews,
    required this.starRating,
    required this.images,
    required this.amenities,
    required this.featured,
    required this.available,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      pricePerNight: json['pricePerNight'].toDouble(),
      guestRating: json['guestRating'].toDouble(),
      totalReviews: json['totalReviews'],
      starRating: json['starRating'],
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      featured: json['featured'],
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'pricePerNight': pricePerNight,
      'guestRating': guestRating,
      'totalReviews': totalReviews,
      'starRating': starRating,
      'images': images,
      'amenities': amenities,
      'featured': featured,
      'available': available,
    };
  }
}
