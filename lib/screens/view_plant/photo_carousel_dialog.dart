import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/providers/photos_provider.dart';
import 'package:plant_application/providers/primary_photo_provider.dart';
import 'package:plant_application/screens/add_photo/add_photo_screen.dart';
import 'package:plant_application/screens/add_plant/image_source_sheet.dart';
import 'package:plant_application/utils/shadows.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class PhotoCarouselDialog extends ConsumerStatefulWidget {
  final int initialIndex;
  final int plantId;

  const PhotoCarouselDialog({
    required this.plantId,
    this.initialIndex = 0,
    super.key,
  });

  @override
  ConsumerState<PhotoCarouselDialog> createState() =>
      _PhotoCarouselDialogState();
}

class _PhotoCarouselDialogState extends ConsumerState<PhotoCarouselDialog> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isExpanded = false;
  bool _isFirst = true;
  bool _isLast = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  void sortPhotos(List<Photo> photos) {
    photos.sort((a, b) {
      if (a.isPrimary && !b.isPrimary) return -1;
      if (!a.isPrimary && b.isPrimary) return 1;

      return b.date.compareTo(a.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final photosAsync = ref.watch(photoNotifierProvider(widget.plantId));
    final shadows = getShadows();

    return photosAsync.when(
      data: (photos) {
        if (photos.isEmpty) {
          Navigator.of(context).pop();
        } else if (photos.length == 1) {
          setState(() {
            _isLast = true;
          });
        }
        sortPhotos(photos);
        Photo currentPhoto = photos[_currentIndex];
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: photos.length,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _isFirst = (index == 0) ? true : false;
                    _isLast = (index == photos.length - 1) ? true : false;
                  });
                },
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: InteractiveViewer(
                      onInteractionStart: (_) {
                        if (!_isExpanded) {
                          setState(() {
                            _isExpanded = true;
                          });
                        }
                      },
                      minScale: 0.1,
                      maxScale: 2.5,
                      child: Image.file(
                        File(photo.filePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              if (!_isFirst)
                Positioned(
                  left: 16,
                  child: AnimatedButton(
                    isVisible: !_isExpanded,
                    child: IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back_ios, shadows: shadows),
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
                ),
              if (!_isLast)
                Positioned(
                  right: 16,
                  child: AnimatedButton(
                    isVisible: !_isExpanded,
                    child: IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      icon: Icon(Icons.arrow_forward_ios, shadows: shadows),
                      onPressed: () {
                        if (_currentIndex < photos.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ),
              if (currentPhoto.notes != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedButton(
                    isVisible: !_isExpanded,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 64, 16, 32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color.fromARGB(178, 0, 0, 0),
                          ],
                        ),
                      ),

                      child: Text(
                        currentPhoto.notes!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          shadows: shadows,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true, // Add this
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedButton(
                  isVisible: !_isExpanded,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 48, 16, 64),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromARGB(178, 0, 0, 0),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: AnimatedButton(
                      isVisible: !_isExpanded,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert, // Horizontal dots instead
                              color: Colors.white,
                              size: 30,
                              shadows: shadows,
                            ),
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onSelected: (String value) async {
                              switch (value) {
                                case 'default':
                                  await ref
                                      .read(
                                        primaryPhotoNotifierProvider(
                                          widget.plantId,
                                        ).notifier,
                                      )
                                      .setPrimary(currentPhoto.id);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                  break;
                                case 'edit':
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => AddPhotoScreen(
                                            plantId: widget.plantId,
                                            initialData: currentPhoto,
                                          ),
                                    ),
                                  );
                                  break;
                                case 'add':
                                  XFile? pickedImage =
                                      await showModalBottomSheet(
                                        context: context,
                                        builder:
                                            (context) => ImageSourceSheet(
                                              onImageSelected: (image) {
                                                Navigator.of(
                                                  context,
                                                ).pop(image);
                                              },
                                            ),
                                      );
                                  if (pickedImage != null && context.mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => AddPhotoScreen(
                                              plantId: widget.plantId,
                                              initialImage: pickedImage,
                                            ),
                                      ),
                                    );
                                  }
                                  break;
                                case 'delete':
                                  ref
                                      .read(
                                        photoNotifierProvider(
                                          currentPhoto.plantId,
                                        ).notifier,
                                      )
                                      .deletePhoto(
                                        photoId: currentPhoto.id,
                                        isPrimary: currentPhoto.isPrimary,
                                      );
                                  if (photos.length <= 1) {
                                    Navigator.of(context).pop();
                                  }
                                  break;
                              }
                            },
                            itemBuilder:
                                (BuildContext context) => [
                                  if (!currentPhoto.isPrimary)
                                    PopupMenuItem<String>(
                                      value: 'default',
                                      child: ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Icons.star,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Make Cover Photo',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'add',
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Add Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.delete,
                                        color: Color.fromRGBO(229, 115, 115, 1),
                                      ),
                                      title: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                            229,
                                            115,
                                            115,
                                            1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                          ),
                          Text(
                            DateTimeHelpers.dateStringToDateTime(
                              currentPhoto.date,
                            ).formatDate(true),
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            iconSize: 30,
                            color: Colors.white,
                            icon: Icon(Icons.close, shadows: shadows),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading:
          () => Scaffold(
            body: Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      error:
          (e, st) => Scaffold(
            body: Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Text("Error loading photos"),
              ),
            ),
          ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final bool isVisible;
  final Widget child;
  final Duration duration;

  const AnimatedButton({
    required this.isVisible,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: duration,
      child: IgnorePointer(ignoring: !isVisible, child: child),
    );
  }
} // class AnimatedButton extends StatelessWidget {
//   final bool isVisible;
//   final Widget child;
//   final Duration duration;

//   const AnimatedButton({
//     required this.isVisible,
//     required this.child,
//     this.duration = const Duration(milliseconds: 200),
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: isVisible ? 0.0 : 1.0, end: isVisible ? 1.0 : 0.0),
//       duration: duration,
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: IgnorePointer(ignoring: value < 0.1, child: this.child),
//         );
//       },
//     );
//   }
// }
