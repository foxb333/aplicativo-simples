import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MeditaEmPazApp());
}

class MeditaEmPazApp extends StatelessWidget {
  const MeditaEmPazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medita em Paz',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
