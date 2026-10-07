class FuelLog {
  final String id;
  final double odometerReading;
  final double fuelVolume;
  final double totalBill;
  final DateTime date;
  final String station;
  final bool isFullTank;

  FuelLog({
    required this.id,
    required this.odometerReading,
    required this.fuelVolume,
    required this.totalBill,
    required this.date,
    required this.station,
    required this.isFullTank,
  });
}
