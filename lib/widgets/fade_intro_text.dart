import 'package:flutter/material.dart';

class FadeIntroText extends StatefulWidget {
  final String text;

  const FadeIntroText({super.key, required this.text});

  @override
  State<FadeIntroText> createState() => _FadeIntroTextState();
}

class _FadeIntroTextState extends State<FadeIntroText> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
