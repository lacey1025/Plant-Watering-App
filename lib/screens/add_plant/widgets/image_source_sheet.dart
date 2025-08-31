import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/theme.dart';

class ImageSourceSheet extends StatelessWidget {
  final void Function(XFile? image) onImageSelected;

  const ImageSourceSheet({super.key, required this.onImageSelected});

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
            onTap: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.camera);
              onImageSelected(picked);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: AppColors.darkTextBlue),
            title: Text(
              'Choose from gallery',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.darkTextBlue),
            ),
            onTap: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(
                source: ImageSource.gallery,
              );
              onImageSelected(picked);
            },
          ),
        ],
      ),
    );
  }
}
