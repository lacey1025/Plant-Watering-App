import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/theme.dart';

Future<int?> showAccessoryDialog(
  BuildContext context,
  WidgetRef ref,
  Accessory? item,
  EventType type,
) {
  final nameController = TextEditingController(text: item?.name ?? "");
  final notesController = TextEditingController(text: item?.notes ?? "");
  final formKey = GlobalKey<FormState>();
  final notifier = ref.read(accessoriesNotifierProvider.notifier);

  return showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Text(
          '${item == null ? "add" : "edit"} ${type == EventType.watering ? "Water Type" : type.toString()}',
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.darkTextBlue,
                  ),
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.darkTextBlue,
                  ),
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: "notes",
                    alignLabelWithHint: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("cancel"),
            onPressed: () => Navigator.of(context).pop(null),
          ),
          ElevatedButton(
            child: const Text("save"),
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final updatedName = nameController.text.trim();
                final updatedNotes = notesController.text.trim();
                final newAccessory = AccessoriesCompanion(
                  id: Value.absentIfNull(item?.id),
                  type: Value(type.toString()),
                  name: Value(updatedName),
                  notes: Value(updatedNotes),
                  isActive: Value(true),
                );
                int? insertedId;
                final navigator = Navigator.of(context);
                if (item == null) {
                  insertedId = await notifier.insertAccessory(newAccessory);
                } else {
                  await notifier.updateAccessory(newAccessory);
                }
                if (navigator.mounted) {
                  navigator.pop(insertedId);
                }
              } else {
                return;
              }
            },
          ),
        ],
      );
    },
  );
}
