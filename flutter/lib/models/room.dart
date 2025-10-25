class Room {
  final String id;
  final String hotelId;
  final String roomType;
  final String description;
  final double pricePerNight;
  final int maxGuests;
  final int totalRooms;
  final int availableRooms;
  final double? size;
  final List<String> images;
  final List<String> amenities;
  final String bedType;
  final bool hasBreakfast;
  final bool freeCancellation;

  Room({
    required this.id,
    required this.hotelId,
    required this.roomType,
    required this.description,
    required this.pricePerNight,
    required this.maxGuests,
    required this.totalRooms,
    required this.availableRooms,
    this.size,
    required this.images,
    required this.amenities,
    required this.bedType,
    required this.hasBreakfast,
    required this.freeCancellation,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      hotelId: json['hotelId'],
      roomType: json['roomType'],
      description: json['description'],
      pricePerNight: json['pricePerNight'].toDouble(),
      maxGuests: json['maxGuests'],
      totalRooms: json['totalRooms'],
      availableRooms: json['availableRooms'],
      size: json['size']?.toDouble(),
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      bedType: json['bedType'],
      hasBreakfast: json['hasBreakfast'],
      freeCancellation: json['freeCancellation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'roomType': roomType,
      'description': description,
      'pricePerNight': pricePerNight,
      'maxGuests': maxGuests,
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'size': size,
      'images': images,
      'amenities': amenities,
      'bedType': bedType,
      'hasBreakfast': hasBreakfast,
      'freeCancellation': freeCancellation,
    };
  }
}
