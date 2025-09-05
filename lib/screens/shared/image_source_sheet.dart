import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/theme.dart';
import 'package:exif/exif.dart';

class ImageSourceSheet extends StatelessWidget {
  final void Function(XFile? image, DateTime? date) onImageSelected;

  const ImageSourceSheet({super.key, required this.onImageSelected});

  static Future<void> show(
    BuildContext context, {
    required void Function(XFile? image, DateTime? date) onImageSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ImageSourceSheet(
            onImageSelected: (image, date) {
              Navigator.pop(context);
              onImageSelected(image, date);
            },
          ),
    );
  }

  /// Parse EXIF "YYYY:MM:DD HH:MM:SS" into DateTime
  DateTime? _parseExifDate(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length != 2) return null;

      final datePart = parts[0].split(':');
      final timePart = parts[1].split(':');

      if (datePart.length != 3 || timePart.length != 3) return null;

      final year = int.parse(datePart[0]);
      final month = int.parse(datePart[1]);
      final day = int.parse(datePart[2]);

      final hour = int.parse(timePart[0]);
      final minute = int.parse(timePart[1]);
      final second = int.parse(timePart[2]);
      return DateTime(year, month, day, hour, minute, second);
    } catch (_) {
      return null;
    }
  }

  /// Extract EXIF date from the picked file
  Future<DateTime?> _getExifDate(XFile file) async {
    try {
      final bytes = await File(file.path).readAsBytes();
      final tags = await readExifFromBytes(bytes);

      final raw = tags['Image DateTime']?.printable;
      if (raw != null) {
        return _parseExifDate(raw);
      }
    } catch (e) {
      debugPrint("Error reading EXIF date: $e");
    }
    return null;
  }

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      final date = await _getExifDate(picked);
      onImageSelected(picked, date);
    } else {
      onImageSelected(null, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt, color: AppColors.darkTextBlue),
            title: Text(
              'Take a photo',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.darkTextBlue),
            ),
            onTap: () => _pick(context, ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: AppColors.darkTextBlue),
            title: Text(
              'Choose from gallery',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.darkTextBlue),
            ),
            onTap: () => _pick(context, ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
