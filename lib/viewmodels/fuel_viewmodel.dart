import 'package:flutter/foundation.dart';
import '../models/fuel_log.dart';
import '../models/vehicle.dart';

class FuelViewModel extends ChangeNotifier {
  // Dummy initial vehicle
  Vehicle _currentVehicle = Vehicle(
    id: 'v1',
    name: 'Bajaj Discover 125',
    averageMileage: 45.0,
  );

  Vehicle get currentVehicle => _currentVehicle;

  // Dummy list of fuel logs
  final List<FuelLog> _fuelLogs = [
    FuelLog(
      id: 'log1',
      odometerReading: 24490,
      fuelVolume: 8.0,
      totalBill: 2800.0,
      date: DateTime.now().subtract(const Duration(days: 5)),
      station: 'CEYPETCO - Polonnaruwa',
      isFullTank: true,
    ),
  ];

  List<FuelLog> get fuelLogs => _fuelLogs;

  // Stats
  double get currentOdometer =>
      _fuelLogs.isNotEmpty ? _fuelLogs.last.odometerReading : 0.0;

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
