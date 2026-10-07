import 'package:flutter/material.dart';

class AddFuelScreen extends StatefulWidget {
  const AddFuelScreen({super.key});

  @override
  State<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends State<AddFuelScreen> {
  bool isFullTank = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Image eke thiyena light background eka
      // 1. Udinma thiyena Blue Bar eka
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD), // Dark Blue color
        elevation: 0,
        leading: const Icon(Icons.directions_car, color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Vaahane',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Add Fuel',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      // 2. Main Body Eka (Scroll karanna puluwan widihata)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(context),
              const SizedBox(height: 20),

              _buildLiveTripCard(),
              const SizedBox(height: 25),

              // Odometer Section
              _buildSectionTitle(Icons.speed, 'Odometer Reading', 'Unit: km'),
              const SizedBox(height: 8),
              _buildCustomTextField(Icons.looks_one_outlined, '24850', 'km'),
              const SizedBox(height: 8),
              _buildHelperText(
                Icons.check,
                Colors.green,
                'Prev: 24,490 km ( ',
                '+360 km',
                ' )',
                'Reset to Previous',
              ),
              const SizedBox(height: 25),

              // Fuel Volume Section
              _buildSectionTitle(
                Icons.local_gas_station_outlined,
                'Fuel Volume',
                'Total pumped',
              ),
              const SizedBox(height: 8),
              _buildCustomTextField(
                Icons.water_drop_outlined,
                '8.00',
                'Liters',
              ),
              const SizedBox(height: 12),
              _buildFuelChips(),
              const SizedBox(height: 25),

              // Total Bill Amount Section
              _buildSectionTitle(
                Icons.account_balance_wallet_outlined,
                'Total Bill Amount',
                'Rs 350.00 / Liter',
              ),
              const SizedBox(height: 8),
              _buildCustomTextField(
                Icons.attach_money,
                '2800.00',
                'LKR',
              ), // LKR use kara Sri Lanka nisa
              const SizedBox(height: 8),
              const Text(
                'Computed based on local standard unleaded petrol tariff',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 25),

              // Station & Time Card
              _buildStationCard(),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {},
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

      // 3. Bottom Navigation Bar eka
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Add Fuel eka select wela thiyenne
        selectedItemColor: const Color(0xFF0D6EFD),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: 'Add Fuel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: 'Maintenance',
          ),
        ],
      ),
    );
  }

  // ---- Helper Functions (UI kalli bedala liyapu widiha) ----

  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF0D6EFD)),
          ),
        ),
        Column(
          children: [
            const Text(
              'Add Fuel Log',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F0FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.motorcycle, size: 14, color: Color(0xFF0D6EFD)),
                  SizedBox(width: 5),
                  Text(
                    'Bajaj Discover 125',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0D6EFD),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.history, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildLiveTripCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0958D9), Color(0xFF4096FF)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LIVE TRIP PROJECTION',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Optimal Range',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                '45.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 5),
                child: Text(
                  'km/L',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.trending_up, color: Colors.greenAccent, size: 18),
              SizedBox(width: 5),
              Text(
                'Trip: 360 km   •   ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.payments_outlined, color: Colors.white70, size: 18),
              SizedBox(width: 5),
              Text(
                'Cost: Rs 7.77 /km',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
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

  // Text box eka custom lassanata hadana function eka
  Widget _buildCustomTextField(IconData icon, String placeholder, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0D6EFD)),
          const SizedBox(width: 15),
          Expanded(
            child: TextFormField(
              initialValue: placeholder,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperText(
    IconData icon,
    Color iconColor,
    String text1,
    String highlight,
    String text2,
    String actionText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 5),
            Text(
              text1,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            Text(
              highlight,
              style: const TextStyle(
                color: Color(0xFF0D6EFD),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              text2,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        Text(
          actionText,
          style: const TextStyle(
            color: Color(0xFF0D6EFD),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFuelChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildChip('+2L', false),
        _buildChip('+5L', false),
        _buildChip('+8L\n(Current)', true), // Active state chip
        _buildChip('+10L', false),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Icon(Icons.water_drop, color: Colors.white, size: 16),
              SizedBox(width: 5),
              Text(
                'Full\nTank',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE5F0FF) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isActive ? const Color(0xFF0D6EFD) : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isActive ? const Color(0xFF0D6EFD) : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Station & Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text(
                  'Log Details',
                  style: TextStyle(
                    color: Color(0xFF0D6EFD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_gas_station,
                color: Colors.green.shade700,
              ),
            ),
            title: const Text(
              'Full Tank Fill-up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Improves mileage calculation accuracy',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Switch(
              value: isFullTank,
              onChanged: (val) {
                setState(() {
                  isFullTank = val;
                });
              },
              activeColor: const Color(0xFF0D6EFD),
            ),
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.grey),
            title: Text(
              'Date & Time',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            subtitle: Text(
              'Today, 10:30 AM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            trailing: Icon(Icons.edit_calendar, size: 20, color: Colors.grey),
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.storefront, color: Colors.grey),
            title: Text(
              'Fuel Station',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            subtitle: Text(
              'CEYPETCO - Polonnaruwa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ), // Oyage area eka damme!
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
