import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/screens/home/home_screen.dart';
import 'package:plant_application/theme.dart';

void main() {
  runApp(ProviderScope(child: PlantApp()));
}

class PlantApp extends StatelessWidget {
  const PlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant App',
      theme: primaryTheme,
      home: const HomeScreen(),
    );
  }
}
