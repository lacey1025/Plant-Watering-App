import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/screens/shared/accessory_dialog.dart';
import 'package:plant_application/theme.dart';

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
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.darkTextGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    final notifier = ref.read(accessoriesNotifierProvider.notifier);

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color:
              item.type == EventType.fertilizer.toString()
                  ? AppColors.primaryYellow
                  : AppColors.primaryPink,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                        softWrap: true,
                      ),
                      Text(
                        item.notes ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              item.type == EventType.fertilizer.toString()
                                  ? AppColors.lightTextYellow
                                  : AppColors.lightTextPink,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),

                IconButton(
                  padding: EdgeInsets.only(left: 8),
                  iconSize: 20,
                  color: Colors.white,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    final type = EventType.toEvent(item.type);
                    if (type == null) return;
                    showAccessoryDialog(context, ref, item, type);
                  },
                ),
                IconButton(
                  iconSize: 20,
                  color: Colors.white,
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
    );
  }
}
