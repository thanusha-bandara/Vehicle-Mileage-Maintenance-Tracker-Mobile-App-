import 'package:cloud_firestore/cloud_firestore.dart';

class FuelLog {
  final String logId;
  final String vehicleId;
  final DateTime date;
  final double liters;
  final double odoReading;
  final double price;

  FuelLog({
    required this.logId,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.odoReading,
    required this.price,
  });

  factory FuelLog.fromJson(Map<String, dynamic> json) {
    // Firestore Timestamp to DateTime conversion
    DateTime parsedDate = DateTime.now();
    if (json['date'] != null) {
      if (json['date'] is Timestamp) {
        parsedDate = (json['date'] as Timestamp).toDate();
      } else if (json['date'] is String) {
        parsedDate = DateTime.parse(json['date']);
      }
    }

    return FuelLog(
      logId: json['logId'] as String? ?? '',
      vehicleId: json['vehicleId'] as String? ?? '',
      date: parsedDate,
      liters: (json['liters'] as num?)?.toDouble() ?? 0.0,
      odoReading: (json['odo_reading'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'vehicleId': vehicleId,
      'date': Timestamp.fromDate(date), // Firestore Timestamp
      'liters': liters,
      'odo_reading': odoReading,
      'price': price,
    };
  }
}
