import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';

Future<int?> addWaterTypeDialog(
  BuildContext context, {
  required EventType type,
  required WidgetRef ref,
}) {
  final nameController = TextEditingController();
  final notesController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final notifier = ref.watch(accessoriesNotifierProvider.notifier);

  return showDialog<int>(
    context: context,
    builder: (context) {
      final title =
          (type == EventType.watering)
              ? "Water"
              : (type == EventType.fertilizer)
              ? "Fertilizer"
              : '';
      return AlertDialog(
        title: Text('Add New $title Type'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: notesController,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null), // cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final accessoryCompanion = notifier.createAccessoryCompanion(
                  type: type,
                  name: nameController.text,
                  notes: notesController.text,
                );
                final navigator = Navigator.of(context);
                final insertedId = await notifier.insertAccessory(
                  accessoryCompanion,
                );
                if (navigator.mounted) {
                  navigator.pop(insertedId);
                }
              } else {
                return;
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
