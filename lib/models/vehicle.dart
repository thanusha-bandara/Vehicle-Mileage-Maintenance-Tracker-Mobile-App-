class Vehicle {
  final String vehicleId;
  final String userId;
  final String name;
  final double averageMileage;

  Vehicle({
    required this.vehicleId,
    required this.userId,
    required this.name,
    this.averageMileage = 0.0,
  });

  // Convert Firestore JSON map to Object
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      averageMileage: (json['averageMileage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert Object to Firestore JSON map
  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'userId': userId,
      'name': name,
      'averageMileage': averageMileage,
    };
  }
}
