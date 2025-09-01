import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigatorBar;
  final Widget? floatingActionButton;

  const BackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigatorBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'lib/assets/img/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: appBar,
          bottomNavigationBar: bottomNavigatorBar,
          floatingActionButton: floatingActionButton,
          body: body,
        ),
      ],
    );
  }
}
