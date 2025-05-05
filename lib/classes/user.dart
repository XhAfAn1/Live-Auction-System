class UserModel {
  String id;
  String name;
  String email;
  String profileImageUrl;
  String phoneNumber;
  String address;
  DateTime createdAt;
  String token;
  bool admin;

  UserModel({
    required this.id,
    required this.name,
    required this.admin,
    required this.email,
    this.profileImageUrl = '',
    this.phoneNumber = '',
    this.address = '',
    this.token = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert UserModel to JSON (for Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'admin': admin,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'address': address,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create UserModel from JSON (for fetching from Firestore/Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      admin: json['admin'] is bool
          ? json['admin']
          : json['admin'].toString().toLowerCase() == 'true',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      token: json['token'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

}
