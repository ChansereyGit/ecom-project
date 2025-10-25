class Booking {
  final String? id;
  final String userId;
  final String hotelId;
  final String hotelName;
  final String roomId;
  final String roomType;
  final String checkInDate;
  final String checkOutDate;
  final int numberOfGuests;
  final int numberOfRooms;
  final int numberOfNights;
  final double totalPrice;
  final String status;
  final String? specialRequests;
  final String guestName;
  final String guestEmail;
  final String guestPhone;

  Booking({
    this.id,
    required this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.roomId,
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.numberOfRooms,
    required this.numberOfNights,
    required this.totalPrice,
    required this.status,
    this.specialRequests,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
      roomId: json['roomId'],
      roomType: json['roomType'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      numberOfGuests: json['numberOfGuests'],
      numberOfRooms: json['numberOfRooms'],
      numberOfNights: json['numberOfNights'],
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
      specialRequests: json['specialRequests'],
      guestName: json['guestName'],
      guestEmail: json['guestEmail'],
      guestPhone: json['guestPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'roomId': roomId,
      'roomType': roomType,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'numberOfGuests': numberOfGuests,
      'numberOfRooms': numberOfRooms,
      'numberOfNights': numberOfNights,
      'totalPrice': totalPrice,
      'status': status,
      if (specialRequests != null) 'specialRequests': specialRequests,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
    };
  }
}
