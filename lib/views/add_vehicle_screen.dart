import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/fuel_viewmodel.dart';
import '../widgets/custom_text_field.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _odoController = TextEditingController();
  
  String _vehicleType = 'Car';
  String _fuelType = 'Petrol 92';

  final List<String> _vehicleTypes = ['Car', 'Bike', 'Van', 'Tuk Tuk', 'SUV'];
  final List<String> _fuelTypes = ['Petrol 92', 'Petrol 95', 'Auto Diesel', 'Super Diesel'];

  @override
  void dispose() {
    _nameController.dispose();
    _odoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fuelViewModel = Provider.of<FuelViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add a Vehicle', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s set up your vehicle',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the details of your vehicle to start tracking fuel and maintenance.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Vehicle Name
            _buildLabel('Vehicle Name (e.g. My Civic, Work Bike)'),
            CustomTextField(
              icon: Icons.directions_car,
              placeholder: 'Vehicle Name',
              unit: '',
              controller: _nameController,
              isNumber: false,
            ),
            const SizedBox(height: 20),

            // Vehicle Type Dropdown
            _buildLabel('Vehicle Type'),
            _buildDropdown(_vehicleTypes, _vehicleType, (val) {
              setState(() => _vehicleType = val!);
            }),
            const SizedBox(height: 20),

            // Fuel Type Dropdown
            _buildLabel('Fuel Type'),
            _buildDropdown(_fuelTypes, _fuelType, (val) {
              setState(() => _fuelType = val!);
            }),
            const SizedBox(height: 20),

            // Initial Odometer
            _buildLabel('Current Odometer Reading'),
            CustomTextField(
              icon: Icons.speed,
              placeholder: '0',
              unit: 'km',
              controller: _odoController,
            ),
            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: fuelViewModel.isLoading
                    ? null
                    : () async {
                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a vehicle name')),
                          );
                          return;
                        }
                        final odo = double.tryParse(_odoController.text) ?? 0.0;

                        await fuelViewModel.saveVehicle(
                          _nameController.text.trim(),
                          _vehicleType,
                          _fuelType,
                          odo,
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D6EFD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: fuelViewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Vehicle',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
