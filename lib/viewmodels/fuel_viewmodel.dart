import 'package:flutter/foundation.dart';
import '../models/fuel_log.dart';
import '../models/vehicle.dart';

class FuelViewModel extends ChangeNotifier {
  // Dummy initial vehicle
  Vehicle _currentVehicle = Vehicle(
    vehicleId: 'v1',
    userId: 'u1',
    name: 'Bajaj Discover 125',
    averageMileage: 45.0,
  );

  Vehicle get currentVehicle => _currentVehicle;

  // Dummy list of fuel logs
  final List<FuelLog> _fuelLogs = [
    FuelLog(
      logId: 'log1',
      vehicleId: 'v1',
      odoReading: 24490,
      liters: 8.0,
      price: 2800.0,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  List<FuelLog> get fuelLogs => _fuelLogs;

  // Stats
  double get currentOdometer =>
      _fuelLogs.isNotEmpty ? _fuelLogs.last.odoReading : 0.0;

  void addFuelLog(FuelLog log) {
    _fuelLogs.add(log);
    // Real implementation would recalculate mileage based on logs here
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) {
    _currentVehicle = vehicle;
    notifyListeners();
  }
}
