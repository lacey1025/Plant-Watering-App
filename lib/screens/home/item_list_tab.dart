import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/screens/shared/accessory_dialog.dart';

class ItemListTab extends ConsumerWidget {
  final List<Accessory> items;
  final String emptyMessage;

  const ItemListTab({
    super.key,
    required this.items,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    final notifier = ref.read(accessoriesNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(item.notes ?? ""),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      final type = EventType.toEvent(item.type);
                      if (type == null) {
                        return;
                      }
                      showAccessoryDialog(context, ref, item, type);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      notifier.deleteAccessory(item.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
