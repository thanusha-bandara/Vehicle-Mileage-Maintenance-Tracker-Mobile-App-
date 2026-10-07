import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/fuel_viewmodel.dart';
import 'add_fuel_screen.dart';
import 'add_vehicle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fuelViewModel = Provider.of<FuelViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final vehicle = fuelViewModel.currentVehicle;

    if (vehicle == null) {
      if (fuelViewModel.isLoading) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator(color: Color(0xFF0D6EFD))),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.black54),
                onPressed: () async => await authViewModel.logout(),
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.directions_car_filled_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                const Text('No vehicles found', style: TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVehicleScreen()));
                  },
                  child: const Text('Add a Vehicle', style: TextStyle(color: Colors.white, fontSize: 16)),
                )
              ],
            ),
          ),
        );
      }
    }

    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF0D6EFD),
              radius: 18,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  authViewModel.user?.email.split('@')[0] ?? 'Driver',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVehicleScreen()));
            },
          ),
          if (fuelViewModel.vehicles.length > 1)
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: vehicle.vehicleId,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                items: fuelViewModel.vehicles.map((v) {
                  return DropdownMenuItem(
                    value: v.vehicleId,
                    child: Text(v.name, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (newId) {
                  if (newId != null) {
                    final selected = fuelViewModel.vehicles.firstWhere((v) => v.vehicleId == newId);
                    fuelViewModel.selectVehicle(selected);
                  }
                },
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54),
            onPressed: () async {
              await authViewModel.logout();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Future functionality to force refresh
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Main Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D6EFD), Color(0xFF0043A8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D6EFD).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vehicle.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Average Mileage',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${vehicle.averageMileage}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6, left: 4),
                            child: Text(
                              'km/L',
                              style: TextStyle(color: Colors.white70, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniStat('Total Spent', currencyFormat.format(fuelViewModel.totalSpentAllTime)),
                          _buildMiniStat('Cost per km', currencyFormat.format(fuelViewModel.costPerKm)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Quick Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context,
                      'Add Fuel',
                      Icons.local_gas_station,
                      const Color(0xFFE3F2FD),
                      const Color(0xFF0D6EFD),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddFuelScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      'Maintenance',
                      Icons.build_circle_outlined,
                      const Color(0xFFFBE9E7),
                      const Color(0xFFD84315),
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Maintenance module coming soon!')),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      'Reports',
                      Icons.pie_chart_outline,
                      const Color(0xFFE8F5E9),
                      const Color(0xFF2E7D32),
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reports module coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                // Recent Fuel Logs Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Fuel Logs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All', style: TextStyle(color: Color(0xFF0D6EFD))),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // Recent Fuel Logs List
                if (fuelViewModel.fuelLogs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.receipt_long, size: 50, color: Colors.grey),
                        SizedBox(height: 15),
                        Text(
                          'No logs found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          'Add your first fuel log to start tracking',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true, // Needed inside SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: fuelViewModel.fuelLogs.length > 5 ? 5 : fuelViewModel.fuelLogs.length,
                    itemBuilder: (context, index) {
                      final log = fuelViewModel.fuelLogs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D6EFD).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.local_gas_station, color: Color(0xFF0D6EFD)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${log.liters.toStringAsFixed(1)} Liters',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(log.date),
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currencyFormat.format(log.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${log.odoReading.toInt()} km',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
  }
}
