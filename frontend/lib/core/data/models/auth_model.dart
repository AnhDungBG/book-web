class User {
  final int? id; // Unique identifier for the user
  final String? name; // User's full name
  final String? username; // Username for login
  final String? avatarUrl; // URL to the user's avatar image
  final String? email; // User's email address
  final String? phoneNumber; // User's phone number
  final DateTime? dateOfBirth; // User's date of birth
  final String? address; // User's address
  final bool? isActive; // Status indicating if the user is active
  final DateTime? createdAt; // Date when the user account was created

  User({
    this.id,
    this.name,
    this.username,
    this.avatarUrl,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.address,
    this.isActive,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // User ID
      name: json['hoten'] ?? json['name'], // Full name
      username: json['username'], // Username
      avatarUrl: json['avatar'] ?? json['avatarUrl'], // Avatar URL
      email: json['email'], // Email
      phoneNumber: json['phoneNumber'], // Phone number
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null, // Date of birth
      address: json['address'], // Address
      isActive: json['isActive'], // Active status
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null, // Creation date
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, username: $username, avatarUrl: $avatarUrl, '
        'email: $email, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, '
        'address: $address, isActive: $isActive, createdAt: $createdAt)';
  }
}
