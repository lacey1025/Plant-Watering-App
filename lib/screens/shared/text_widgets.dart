import 'package:flutter/material.dart';

class SectionTitleText extends StatelessWidget {
  final String text;
  final Color color;

  const SectionTitleText(this.text, {super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }
}
