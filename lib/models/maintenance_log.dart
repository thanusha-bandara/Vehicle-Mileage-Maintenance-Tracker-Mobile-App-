import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceLog {
  final String serviceId;
  final String vehicleId;
  final String type;
  final DateTime date;
  final double nextDueKm;

  MaintenanceLog({
    required this.serviceId,
    required this.vehicleId,
    required this.type,
    required this.date,
    required this.nextDueKm,
  });

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['date'] != null) {
      if (json['date'] is Timestamp) {
        parsedDate = (json['date'] as Timestamp).toDate();
      } else if (json['date'] is String) {
        parsedDate = DateTime.parse(json['date']);
      }
    }

    return MaintenanceLog(
      serviceId: json['serviceId'] as String? ?? '',
      vehicleId: json['vehicleId'] as String? ?? '',
      type: json['type'] as String? ?? '',
      date: parsedDate,
      nextDueKm: (json['next_due_km'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'vehicleId': vehicleId,
      'type': type,
      'date': Timestamp.fromDate(date),
      'next_due_km': nextDueKm,
    };
  }
}
