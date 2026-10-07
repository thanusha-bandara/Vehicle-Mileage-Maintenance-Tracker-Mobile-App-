import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/fuel_viewmodel.dart';
import '../models/vehicle.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/live_trip_card.dart';

class AddFuelScreen extends StatefulWidget {
  const AddFuelScreen({super.key});

  @override
  State<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends State<AddFuelScreen> {
  final TextEditingController _odoController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  double _fuelPricePerLiter = 368.0; // Default Petrol 92
  bool _isAutoCalculating = false;
  bool _isFullTank = false;

  @override
  void initState() {
    super.initState();
    // Schedule initialization after the first frame to get Provider context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFuelPrice();
    });

    _litersController.addListener(_onLitersChanged);
    _priceController.addListener(_onPriceChanged);
  }

  void _initFuelPrice() {
    final vehicle = Provider.of<FuelViewModel>(context, listen: false).currentVehicle;
    if (vehicle != null) {
      switch (vehicle.fuelType) {
        case 'Petrol 92': _fuelPricePerLiter = 368.0; break;
        case 'Petrol 95': _fuelPricePerLiter = 420.0; break;
        case 'Auto Diesel': _fuelPricePerLiter = 333.0; break;
        case 'Super Diesel': _fuelPricePerLiter = 377.0; break;
        default: _fuelPricePerLiter = 368.0;
      }
    }
  }

  void _onLitersChanged() {
    if (_isAutoCalculating || _litersController.text.isEmpty) return;
    _isAutoCalculating = true;
    final liters = double.tryParse(_litersController.text);
    if (liters != null) {
      _priceController.text = (liters * _fuelPricePerLiter).toStringAsFixed(2);
    }
    _isAutoCalculating = false;
  }

  void _onPriceChanged() {
    if (_isAutoCalculating || _priceController.text.isEmpty) return;
    _isAutoCalculating = true;
    final price = double.tryParse(_priceController.text);
    if (price != null && _fuelPricePerLiter > 0) {
      _litersController.text = (price / _fuelPricePerLiter).toStringAsFixed(2);
    }
    _isAutoCalculating = false;
  }

  @override
  void dispose() {
    _odoController.dispose();
    _litersController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data from MVVM Provider
    final fuelViewModel = Provider.of<FuelViewModel>(context);
    final vehicle = fuelViewModel.currentVehicle;

    if (vehicle == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD), // Dark Blue color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Fuel Log',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              vehicle.name,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LiveTripCard(vehicle: vehicle),
              const SizedBox(height: 25),

              // Odometer Section
              _buildSectionTitle(Icons.speed, 'Odometer Reading', 'Unit: km'),
              const SizedBox(height: 8),
              CustomTextField(
                icon: Icons.looks_one_outlined,
                placeholder: fuelViewModel.currentOdometer.toString(),
                unit: 'km',
                controller: _odoController,
              ),
              const SizedBox(height: 25),

              // Fuel Volume Section
              _buildSectionTitle(
                Icons.local_gas_station_outlined,
                'Fuel Volume',
                'Total pumped',
              ),
              const SizedBox(height: 8),
              CustomTextField(
                icon: Icons.water_drop_outlined,
                placeholder: '0.00',
                unit: 'Liters',
                controller: _litersController,
              ),
              const SizedBox(height: 25),

              // Total Bill Amount Section
              _buildSectionTitle(
                Icons.account_balance_wallet_outlined,
                'Total Bill Amount',
                'LKR',
              ),
              const SizedBox(height: 8),
              CustomTextField(
                icon: Icons.attach_money,
                placeholder: '0.00',
                unit: 'LKR',
                controller: _priceController,
              ),
              const SizedBox(height: 15),

              // Full Tank Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Full Tank Fill-up',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Check this if you filled the tank to the top. Required for accurate mileage calculation.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                value: _isFullTank,
                onChanged: (val) {
                  setState(() {
                    _isFullTank = val ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF0D6EFD),
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: fuelViewModel.isLoading
                      ? null
                      : () async {
                          final odo = double.tryParse(_odoController.text) ?? 0;
                          final liters = double.tryParse(_litersController.text) ?? 0;
                          final price = double.tryParse(_priceController.text) ?? 0;

                          if (odo <= 0 || liters <= 0 || price <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter valid numbers')),
                            );
                            return;
                          }

                          await fuelViewModel.addFuelLog(odo, liters, price, _isFullTank);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                  icon: fuelViewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                  label: Text(
                    fuelViewModel.isLoading ? 'Saving...' : 'Save Fuel Log',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0D6EFD), size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
