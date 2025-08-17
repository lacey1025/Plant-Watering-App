import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/providers/db_provider.dart';
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
            final sortedPhotos = [...photos]
              ..sort((a, b) => b.date.compareTo(a.date));
            state = AsyncValue.data(sortedPhotos);
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

  Future<void> insertPhoto({
    required int plantId,
    required String photoPath,
  }) async {
    final db = ref.read(databaseProvider);
    await db.photosDao.insertPhoto(
      PhotosCompanion(
        plantId: Value(plantId),
        filePath: Value(photoPath),
        date: Value(DateTime.now().dateTimeToDateString()),
      ),
    );
  }

  bool hasRecentPhoto(DateTime dateAdded) {
    if (state.value == null) return false;

    final photos = state.value;
    if (photos == null) return false;

    final today = DateTime.now();
    final monthsPassed =
        (today.year - dateAdded.year) * 12 + (today.month - dateAdded.month);
    final periodsPassed = monthsPassed ~/ 6;

    // if (periodsPassed < 1) return const SizedBox.shrink();

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
