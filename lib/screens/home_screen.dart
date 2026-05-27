import 'package:flutter/material.dart';
import '../animations/page_transitions.dart';
import 'meditation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medita em Paz")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransitions.fadeRoute(const MeditationScreen()),
            );
          },
          child: const Text("Escolher sessão"),
        ),
      ),
    );
  }
}
