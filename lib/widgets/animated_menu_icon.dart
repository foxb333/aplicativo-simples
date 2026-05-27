import 'package:flutter/material.dart';

class AnimatedMenuIcon extends StatefulWidget {
  final IconData icon;

  const AnimatedMenuIcon({super.key, required this.icon});

  @override
  State<AnimatedMenuIcon> createState() => _AnimatedMenuIconState();
}

class _AnimatedMenuIconState extends State<AnimatedMenuIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Icon(widget.icon, size: 30),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
