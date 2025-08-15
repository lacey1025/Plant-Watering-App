import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final void Function(XFile? image) onImageSelected;

  const ImageSourceSheet({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () async {
              Navigator.pop(context);
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.camera);
              onImageSelected(picked);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () async {
              Navigator.pop(context);
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
