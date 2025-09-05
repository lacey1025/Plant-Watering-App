import 'package:flutter/material.dart';
import 'package:plant_application/theme.dart';

class DeleteDialog extends StatelessWidget {
  final String? itemName;
  const DeleteDialog({super.key, this.itemName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('confirm delete'),
      content: Text(
        itemName != null
            ? 'are you sure you want to delete $itemName?'
            : 'are you sure you want to delete this plant?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('delete'),
        ),
      ],
    );
  }
}
