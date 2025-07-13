enum UserRole { barber, customer }

class User {
  final String id;
  final String name;
  final String contactNumber;
  final String password;
  final UserRole role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.password,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'password': password,
      'role': role.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contactNumber'],
      password: json['password'],
      role: UserRole.values.firstWhere((e) => e.toString() == json['role']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String contactNumber;
  final DateTime addedTime;
  bool isCompleted;

  Customer({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.addedTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'addedTime': addedTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contactNumber'],
      addedTime: DateTime.parse(json['addedTime']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
