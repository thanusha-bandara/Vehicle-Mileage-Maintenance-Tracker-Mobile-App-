import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart'; // Api kalin file eka methanata link karanawa
import 'viewmodels/fuel_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FuelViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:
          false, // Right corner eke debug lable eka ain karanna
      home: HomeScreen(), // App eka open weddi Home Screen eka pennanna
    );
  }
}
