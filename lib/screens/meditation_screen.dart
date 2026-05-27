import 'package:flutter/material.dart';
import '../widgets/start_button.dart';
import '../widgets/fade_intro_text.dart';
import '../widgets/animated_menu_icon.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  bool menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sessão de Meditação")),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔥 ÁREA CENTRAL REALMENTE FIXA
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    FadeIntroText(text: "Respire fundo e relaxe sua mente..."),
                    SizedBox(height: 40),
                    StartButton(),
                  ],
                ),
              ),

              /// MENU BUTTON
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() => menuOpen = !menuOpen);
                },
              ),

              /// MENU ANIMADO
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child:
                    menuOpen
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            AnimatedMenuIcon(icon: Icons.settings),
                            SizedBox(width: 20),
                            AnimatedMenuIcon(icon: Icons.music_note),
                            SizedBox(width: 20),
                            AnimatedMenuIcon(icon: Icons.timer),
                          ],
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
