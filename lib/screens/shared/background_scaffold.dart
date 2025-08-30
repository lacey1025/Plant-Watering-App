import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const BackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/img/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          body,
        ],
      ),
    );
  }
}
