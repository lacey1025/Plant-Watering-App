import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/notifier_providers/photos_provider.dart';
import 'package:plant_application/screens/add_photo/add_photo_screen.dart';
import 'package:plant_application/screens/shared/image_source_sheet.dart';
import 'package:plant_application/theme.dart';

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
          return Padding(
            padding: EdgeInsets.only(top: 8),
            child: MaterialBanner(
              backgroundColor: AppColors.lightTextPink,
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              minActionBarHeight: 32,
              content: Text(
                "Happy 6-monthiversary to your plant! Take a photo to celebrate!",
                // textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.darkTextPink),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await _showImageSourceActionSheet(context, ref);
                  },
                  child: Text(
                    'Take Photo',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkTextPink,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(photoBannerVisibleProvider(plantId).notifier)
                        .state = false;
                  },
                  child: Text(
                    'Dismiss',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkTextPink,
                    ),
                  ),
                ),
              ],
            ),
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
    await ImageSourceSheet.show(
      context,
      onImageSelected: (image, date) {
        if (image != null && context.mounted) {
          ref.read(photoBannerVisibleProvider(plantId).notifier).state = false;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => AddPhotoScreen(
                    plantId: plantId,
                    initialImage: image,
                    initialDate: date,
                  ),
            ),
          );
        }
      },
    );
  }
}

final photoBannerVisibleProvider = StateProvider.family<bool, int>(
  (ref, plantId) => true,
);
