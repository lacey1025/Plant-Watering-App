import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plant_application/database/plant_app_db.dart';

class PhotoCarouselDialog extends StatefulWidget {
  final List<Photo> photos;
  final int initialIndex;

  const PhotoCarouselDialog({
    required this.photos,
    this.initialIndex = 0,
    super.key,
  });

  @override
  State<PhotoCarouselDialog> createState() => _PhotoCarouselDialogState();
}

class _PhotoCarouselDialogState extends State<PhotoCarouselDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(8),
      backgroundColor: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final photo = widget.photos[index];
              return InteractiveViewer(
                child: Image.file(File(photo.filePath), fit: BoxFit.contain),
              );
            },
          ),
          Positioned(
            left: 16,
            child: IconButton(
              iconSize: 40,
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (_currentIndex > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            right: 16,
            child: IconButton(
              iconSize: 40,
              color: Colors.white,
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                if (_currentIndex < widget.photos.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
