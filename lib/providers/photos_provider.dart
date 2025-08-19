import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/providers/db_provider.dart';
import 'package:plant_application/providers/primary_photo_provider.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class PhotoNotifier extends StateNotifier<AsyncValue<List<Photo>>> {
  final Ref ref;
  final int plantId;
  StreamSubscription<List<Photo>>? _photosSub;

  PhotoNotifier(this.ref, this.plantId) : super(const AsyncValue.loading()) {
    _listenToPhotos();
  }

  void _listenToPhotos() {
    final db = ref.read(databaseProvider);
    _photosSub = db.photosDao
        .watchAllPhotosForPlant(plantId)
        .listen(
          (photos) {
            state = AsyncValue.data(photos);
          },
          onError: (error, stack) {
            state = AsyncValue.error(error, stack);
          },
        );
  }

  Future<String?> savePhoto(XFile pickedImage) async {
    final bytes = await pickedImage.readAsBytes();
    final appDir = await getApplicationDocumentsDirectory();

    final imageDir = Directory('${appDir.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final savedImage = File(
      '${imageDir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg',
    );
    await savedImage.writeAsBytes(bytes);
    return savedImage.path;
  }

  Future<void> insertPhoto(PhotosCompanion photo) async {
    final db = ref.read(databaseProvider);
    final isPrimary = photo.isPrimary.value;
    await db.transaction(() async {
      final photoId = await db.photosDao.insertPhoto(photo);
      if (isPrimary) {
        await db.photosDao.makePrimary(photoId, plantId);
      }
    });
    if (isPrimary) {
      ref.invalidate(primaryPhotoNotifierProvider);
    }
  }

  Future<void> updatePhoto(PhotosCompanion photo) async {
    final db = ref.read(databaseProvider);
    final isPrimary = photo.isPrimary.value;
    db.transaction(() async {
      await db.photosDao.updatePhoto(photo);
      if (isPrimary) {
        await db.photosDao.makePrimary(photo.id.value, plantId);
      }
    });
    if (isPrimary) {
      ref.invalidate(primaryPhotoNotifierProvider);
    }
  }

  Future<void> deletePhoto({
    required int photoId,
    required bool isPrimary,
  }) async {
    final db = ref.read(databaseProvider);
    await db.photosDao.deletePhoto(photoId);
    if (isPrimary) {
      final mostRecent = await db.photosDao.getMostRecentPhoto(plantId);
      if (mostRecent != null) {
        await ref
            .read(primaryPhotoNotifierProvider(plantId).notifier)
            .setPrimary(mostRecent.id);
      }
    }

    ref.invalidate(primaryPhotoNotifierProvider(plantId));
  }

  bool isEmpty() {
    if (state.value != null) {
      return (state.value!.isEmpty);
    }
    return true;
  }

  bool hasRecentPhoto(DateTime dateAdded) {
    if (state.value == null) {
      return true;
    }

    final photos = state.value;
    if (photos == null) {
      return true;
    }

    final today = DateTime.now();
    final monthsPassed =
        (today.year - dateAdded.year) * 12 + (today.month - dateAdded.month);

    final periodsPassed = monthsPassed ~/ 6;

    if (periodsPassed < 1) {
      return true;
    }

    // Calculate most recent 6-month anniversary
    final lastAnniversary = DateTime(
      dateAdded.year,
      dateAdded.month + periodsPassed * 6,
      dateAdded.day,
    );

    return photos.any(
      (photo) => DateTimeHelpers.dateStringToDateTime(
        photo.date,
      ).isAfter(lastAnniversary),
    );
  }

  @override
  void dispose() {
    _photosSub?.cancel();
    super.dispose();
  }
}

final photoNotifierProvider =
    StateNotifierProvider.family<PhotoNotifier, AsyncValue<List<Photo>>, int>((
      ref,
      plantId,
    ) {
      return PhotoNotifier(ref, plantId);
    });
