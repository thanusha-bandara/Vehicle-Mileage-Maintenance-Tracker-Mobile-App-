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
  @override
  Widget build(BuildContext context) {
    // Fetch data from MVVM Provider
    final fuelViewModel = Provider.of<FuelViewModel>(context);
    final vehicle = fuelViewModel.currentVehicle;

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
              const CustomTextField(
                icon: Icons.looks_one_outlined,
                placeholder: '0',
                unit: 'km',
              ),
              const SizedBox(height: 25),

              // Fuel Volume Section
              _buildSectionTitle(
                Icons.local_gas_station_outlined,
                'Fuel Volume',
                'Total pumped',
              ),
              const SizedBox(height: 8),
              const CustomTextField(
                icon: Icons.water_drop_outlined,
                placeholder: '0.00',
                unit: 'Liters',
              ),
              const SizedBox(height: 25),

              // Total Bill Amount Section
              _buildSectionTitle(
                Icons.account_balance_wallet_outlined,
                'Total Bill Amount',
                'LKR',
              ),
              const SizedBox(height: 8),
              const CustomTextField(
                icon: Icons.attach_money,
                placeholder: '0.00',
                unit: 'LKR',
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Connect to ViewModel to save
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Save Fuel Log',
                    style: TextStyle(
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
