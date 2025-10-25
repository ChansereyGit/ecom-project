class User {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String role;
  final bool emailVerified;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      emailVerified: json['emailVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'emailVerified': emailVerified,
    };
  }
}
