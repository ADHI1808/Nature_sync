import 'package:flutter/material.dart';

import 'package:my_tflit_app/presentation/screens/dashboard/dashboard_screen.dart';
class my_tflite_app extends StatelessWidget {
  const my_tflite_app({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}
