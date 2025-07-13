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
