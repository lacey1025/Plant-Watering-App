import 'dart:io';

import 'package:flutter/material.dart';

class FullscreenImagePage extends StatelessWidget {
  final String imagePath;

  const FullscreenImagePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: 'imageHero',
              child: InteractiveViewer(child: Image.file(File(imagePath))),
            ),
          ),
          Positioned(
            top: 64,
            right: 8,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
