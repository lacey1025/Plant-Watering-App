import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String? itemName;
  const DeleteDialog({super.key, this.itemName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: Text(
        itemName != null
            ? 'Are you sure you want to delete $itemName?'
            : 'Are you sure you want to delete this plant?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
