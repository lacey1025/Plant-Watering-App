import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/notifier_providers/primary_photo_provider.dart';
import 'package:plant_application/screens/add_photo/add_photo_screen.dart';
import 'package:plant_application/screens/view_plant/widgets/photo_carousel_dialog.dart';
import 'package:plant_application/utils/shadows.dart';

class PlantAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final int plantId;
  final AsyncValue<PlantCardData?> plantAsync;

  const PlantAppBar({
    required this.plantId,
    required this.plantAsync,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 120);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryPhotoAsync = ref.watch(primaryPhotoNotifierProvider(plantId));

    return primaryPhotoAsync.when(
      data: (photo) {
        final backgroundPhoto = photo;

        return AppBar(
          backgroundColor:
              backgroundPhoto != null
                  ? Colors.transparent
                  : Theme.of(context).primaryColor,
          elevation: 0,
          toolbarHeight: kToolbarHeight + 120,
          flexibleSpace: GestureDetector(
            onTap: () {
              if (photo != null) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            PhotoCarouselDialog(
                              plantId: plantId,
                              initialIndex: 0,
                            ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              } else {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, _, _) => AddPhotoScreen(plantId: plantId),
                  ),
                );
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image or color
                if (backgroundPhoto != null)
                  Image.file(
                    File(backgroundPhoto.filePath),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Container(color: Theme.of(context).primaryColor),
                  )
                else
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Icon(
                        Icons.photo_camera,
                        color: Colors.white12,
                        size: 48,
                      ),
                    ),
                  ),

                // Dim overlay for better text readability
                Container(color: Colors.black12),

                // Title positioned at bottom of the extended app bar
                Positioned(
                  bottom: 16,
                  left: 56, // Account for back button width
                  right: 16,
                  child: plantAsync.when(
                    data:
                        (plant) => Text(
                          plant == null ? "View Plant" : plant.plant.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            shadows:
                                backgroundPhoto != null
                                    ? getShadows()
                                    // backgroundPhoto != null
                                    //     ? [
                                    //       const Shadow(
                                    //         offset: Offset(1, 1),
                                    //         blurRadius: 20,
                                    //         color: Color.fromARGB(100, 0, 0, 0),
                                    //       ),
                                    //       const Shadow(
                                    //         offset: Offset(-1, 1),
                                    //         blurRadius: 20,
                                    //         color: Color.fromARGB(100, 0, 0, 0),
                                    //       ),
                                    //       const Shadow(
                                    //         offset: Offset(1, -1),
                                    //         blurRadius: 20,
                                    //         color: Color.fromARGB(100, 0, 0, 0),
                                    //       ),
                                    //       const Shadow(
                                    //         offset: Offset(-1, -1),
                                    //         blurRadius: 20,
                                    //         color: Color.fromARGB(100, 0, 0, 0),
                                    //       ),
                                    //     ]
                                    : null,
                          ),
                        ),
                    loading:
                        () => const Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                    error:
                        (e, st) => const Text(
                          'Error',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                  ),
                ),
              ],
            ),
          ),
          // Make sure the back button and any actions are visible
          foregroundColor: Colors.white,
        );
      },
      loading:
          () => AppBar(
            title: const Text('Loading...'),
            toolbarHeight: kToolbarHeight + 120,
            backgroundColor: Theme.of(context).primaryColor,
          ),
      error:
          (_, __) => AppBar(
            title: const Text('Error'),
            toolbarHeight: kToolbarHeight + 120,
            backgroundColor: Theme.of(context).primaryColor,
          ),
    );
  }
}
