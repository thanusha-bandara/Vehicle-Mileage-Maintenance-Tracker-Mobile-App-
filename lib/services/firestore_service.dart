import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fuel_log.dart';
import '../models/vehicle.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a new vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    await _db
        .collection('vehicles')
        .doc(vehicle.vehicleId)
        .set(vehicle.toJson());
  }

  // Get user's vehicles
  Stream<List<Vehicle>> getUserVehicles(String userId) {
    return _db
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Vehicle.fromJson(doc.data()))
            .toList());
  }

  // Add a new fuel log
  Future<void> addFuelLog(FuelLog log) async {
    final docRef = _db.collection('fuel_logs').doc(); // Auto generate ID
    
    // Create new log with the generated ID
    final newLog = FuelLog(
      logId: docRef.id,
      vehicleId: log.vehicleId,
      date: log.date,
      liters: log.liters,
      odoReading: log.odoReading,
      price: log.price,
    );

    await docRef.set(newLog.toJson());

    // After adding fuel log, update vehicle's average mileage
    await updateVehicleMileage(log.vehicleId);
  }

  // Get all fuel logs for a specific vehicle
  Stream<List<FuelLog>> getVehicleFuelLogs(String vehicleId) {
    return _db
        .collection('fuel_logs')
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snapshot) {
      final logs = snapshot.docs
          .map((doc) => FuelLog.fromJson(doc.data()))
          .toList();
      // Sort locally to avoid Firebase Composite Index requirement
      logs.sort((a, b) => b.date.compareTo(a.date));
      return logs;
    });
  }

  // Calculate and update the average mileage for a vehicle
  Future<void> updateVehicleMileage(String vehicleId) async {
    final querySnapshot = await _db
        .collection('fuel_logs')
        .where('vehicleId', isEqualTo: vehicleId)
        .get();

    if (querySnapshot.docs.length < 2) {
      // Need at least 2 logs to calculate distance between them
      return;
    }

    final logs = querySnapshot.docs
        .map((doc) => FuelLog.fromJson(doc.data()))
        .toList();
    
    // Sort locally (oldest first)
    logs.sort((a, b) => a.date.compareTo(b.date));

    double newAvgMileage = 0.0;
    final fullTankLogs = logs.where((l) => l.isFullTank).toList();

    if (fullTankLogs.length >= 2) {
      // Accurate Full Tank Method
      final firstFull = fullTankLogs.first;
      final lastFull = fullTankLogs.last;
      
      double totalDistance = lastFull.odoReading - firstFull.odoReading;
      double totalLiters = 0.0;
      
      bool startCounting = false;
      for (final log in logs) {
        if (log.logId == firstFull.logId) {
          startCounting = true;
          continue; // Skip the liters added at the start of the measurement
        }
        if (startCounting) {
          totalLiters += log.liters;
        }
        if (log.logId == lastFull.logId) {
          break;
        }
      }
      
      if (totalLiters > 0 && totalDistance > 0) {
        newAvgMileage = totalDistance / totalLiters;
      }
    } else {
      // Fallback basic calculation
      double totalDistance = 0.0;
      double totalLiters = 0.0;

      for (int i = 1; i < logs.length; i++) {
        double distance = logs[i].odoReading - logs[i - 1].odoReading;
        if (distance > 0) {
          totalDistance += distance;
          totalLiters += logs[i].liters;
        }
      }

      if (totalLiters > 0) {
        newAvgMileage = totalDistance / totalLiters;
      }
    }

    // Update vehicle document
    await _db.collection('vehicles').doc(vehicleId).update({
      'averageMileage': double.parse(newAvgMileage.toStringAsFixed(2)),
    });
  }
}
