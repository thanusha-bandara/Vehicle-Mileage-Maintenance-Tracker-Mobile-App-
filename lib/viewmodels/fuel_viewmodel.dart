import 'package:flutter/foundation.dart';
import '../models/fuel_log.dart';
import '../models/vehicle.dart';

import '../services/firestore_service.dart';

class FuelViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  Vehicle? _currentVehicle;
  Vehicle? get currentVehicle => _currentVehicle;

  List<FuelLog> _fuelLogs = [];
  List<FuelLog> get fuelLogs => _fuelLogs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _userId;

  // Initialize and load data for the logged-in user
  void loadDataForUser(String userId) {
    if (_userId == userId) return; // Already loaded
    _userId = userId;
    _setLoading(true);

    // Listen to vehicle updates
    _firestoreService.getUserVehicles(userId).listen((userVehicles) async {
      _vehicles = userVehicles;
      
      if (_vehicles.isNotEmpty) {
        // If current vehicle is not in the list or null, pick the first one
        if (_currentVehicle == null || !_vehicles.any((v) => v.vehicleId == _currentVehicle!.vehicleId)) {
          selectVehicle(_vehicles.first);
        } else {
          // Update current vehicle with new data
          _currentVehicle = _vehicles.firstWhere((v) => v.vehicleId == _currentVehicle!.vehicleId);
          notifyListeners();
        }
      } else {
        _currentVehicle = null;
        _fuelLogs = [];
        notifyListeners();
      }
      _setLoading(false);
    });
  }

  void selectVehicle(Vehicle vehicle) {
    _currentVehicle = vehicle;
    _listenToFuelLogs(vehicle.vehicleId);
    notifyListeners();
  }

  void _listenToFuelLogs(String vehicleId) {
    _firestoreService.getVehicleFuelLogs(vehicleId).listen((logs) {
      _fuelLogs = logs;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Stats
  double get currentOdometer =>
      _fuelLogs.isNotEmpty ? _fuelLogs.first.odoReading : 0.0;

  double get totalSpentAllTime {
    return _fuelLogs.fold(0.0, (sum, log) => sum + log.price);
  }

  double get totalSpentThisMonth {
    final now = DateTime.now();
    return _fuelLogs
        .where((log) => log.date.year == now.year && log.date.month == now.month)
        .fold(0.0, (sum, log) => sum + log.price);
  }

  // Cost per km metric
  double get costPerKm {
    if (_fuelLogs.isEmpty || _currentVehicle == null) return 0.0;
    
    // Find the oldest log to determine total distance covered
    // Or just use currentOdo - initialOdo
    final initialOdo = _currentVehicle!.initialOdometer;
    final currentOdo = currentOdometer;
    
    if (currentOdo <= initialOdo) return 0.0;
    
    return totalSpentAllTime / (currentOdo - initialOdo);
  }

  // Get efficiency between the last two logs (just as an example metric)
  double get latestEfficiency {
    if (_fuelLogs.length < 2) return 0.0;
    final lastLog = _fuelLogs[0];
    final prevLog = _fuelLogs[1];
    final distance = lastLog.odoReading - prevLog.odoReading;
    if (distance <= 0 || lastLog.liters <= 0) return 0.0;
    return distance / lastLog.liters;
  }

  Future<void> addFuelLog(double odoReading, double liters, double price, bool isFullTank) async {
    if (_currentVehicle == null) return;
    
    _setLoading(true);
    
    final newLog = FuelLog(
      logId: '', // Will be generated in service
      vehicleId: _currentVehicle!.vehicleId,
      date: DateTime.now(),
      liters: liters,
      odoReading: odoReading,
      price: price,
      isFullTank: isFullTank,
    );

    await _firestoreService.addFuelLog(newLog);
    _setLoading(false);
  }

  Future<void> saveVehicle(String name, String vehicleType, String fuelType, double initialOdo) async {
    if (_userId == null) return;
    _setLoading(true);
    
    final newVehicle = Vehicle(
      vehicleId: 'veh_${DateTime.now().millisecondsSinceEpoch}',
      userId: _userId!,
      name: name,
      vehicleType: vehicleType,
      fuelType: fuelType,
      initialOdometer: initialOdo,
      averageMileage: 0.0,
    );
    
    await _firestoreService.addVehicle(newVehicle);
    _setLoading(false);
  }
}
