class UserModel {
  String id;
  String name;
  String email;
  String profileImageUrl;
  String phoneNumber;
  String address;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl = '',
    this.phoneNumber = '',
    this.address = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert UserModel to JSON (for Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create UserModel from JSON (for fetching from Firestore/Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
