import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/notifier_providers/photos_provider.dart';
import 'package:plant_application/screens/add_photo/add_photo_screen.dart';
import 'package:plant_application/screens/add_plant/widgets/image_source_sheet.dart';

class PhotoReminderBanner extends ConsumerWidget {
  final DateTime dateAdded;
  final int plantId;

  const PhotoReminderBanner({
    super.key,
    required this.dateAdded,
    required this.plantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBeenDismissed = ref.watch(photoBannerVisibleProvider(plantId));
    if (!hasBeenDismissed) return const SizedBox.shrink();
    final photosAsync = ref.watch(photoNotifierProvider(plantId));
    final photoNotifier = ref.read(photoNotifierProvider(plantId).notifier);

    return photosAsync.when(
      data: (photos) {
        final hasRecentPhoto = photoNotifier.hasRecentPhoto(dateAdded);

        if (!hasRecentPhoto) {
          return MaterialBanner(
            content: Text(
              "Happy 6-monthiversary to your plant! Take a photo to celebrate!",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _showImageSourceActionSheet(context, ref);
                },
                child: const Text('Take Photo'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(photoBannerVisibleProvider(plantId).notifier).state =
                      false;
                },
                child: const Text('Dismiss'),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }

  Future<void> _showImageSourceActionSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    XFile? pickedImage = await showModalBottomSheet(
      context: context,
      builder:
          (context) => ImageSourceSheet(
            onImageSelected: (image) {
              Navigator.of(context).pop(image);
            },
          ),
    );
    if (pickedImage != null && context.mounted) {
      // ref.read(photoBannerVisibleProvider(plantId).notifier).state = false;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (_) =>
                  AddPhotoScreen(plantId: plantId, initialImage: pickedImage),
        ),
      );
    }
  }
}

final photoBannerVisibleProvider = StateProvider.family<bool, int>(
  (ref, plantId) => true,
);
