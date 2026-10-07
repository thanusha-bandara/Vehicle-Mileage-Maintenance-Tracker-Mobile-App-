class Vehicle {
  final String vehicleId;
  final String userId;
  final String name;
  final String vehicleType;
  final String fuelType;
  final double initialOdometer;
  final double averageMileage;

  Vehicle({
    required this.vehicleId,
    required this.userId,
    required this.name,
    this.vehicleType = 'Car',
    this.fuelType = 'Petrol 92',
    this.initialOdometer = 0.0,
    this.averageMileage = 0.0,
  });

  // Convert Firestore JSON map to Object
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      vehicleType: json['vehicleType'] as String? ?? 'Car',
      fuelType: json['fuelType'] as String? ?? 'Petrol 92',
      initialOdometer: (json['initialOdometer'] as num?)?.toDouble() ?? 0.0,
      averageMileage: (json['averageMileage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert Object to Firestore JSON map
  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'userId': userId,
      'name': name,
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'initialOdometer': initialOdometer,
      'averageMileage': averageMileage,
    };
  }
}
