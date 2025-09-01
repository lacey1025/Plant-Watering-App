import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/notifier_providers/plant_provider.dart';
import 'package:plant_application/screens/add_plant/add_plant_screen.dart';
import 'package:plant_application/screens/add_plant/plant_form_data.dart';
import 'package:plant_application/screens/home/home_screen.dart';
import 'package:plant_application/screens/view_plant/widgets/delete_dialog.dart';
import 'package:plant_application/screens/view_plant/widgets/photo_reminder_banner.dart';
import 'package:plant_application/theme.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class BottomButtons extends ConsumerWidget {
  final PlantCardData plant;
  const BottomButtons({super.key, required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(plantNotifierProvider(plant.plant.id).notifier);

    return Column(
      children: [
        PhotoReminderBanner(
          dateAdded: DateTimeHelpers.dateStringToDateTime(
            plant.plant.dateAdded,
          ),
          plantId: plant.plant.id,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondaryBlue,
                  foregroundColor: AppColors.darkTextBlue,
                ),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => DeleteDialog(itemName: plant.plant.name),
                  );
                  if (confirmed == true && context.mounted) {
                    await notifier.deletePlant();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    }
                  }
                },
                child: const Text("delete plant"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  final plantForm = PlantFormData(
                    id: plant.plant.id,
                    name: plant.plant.name,
                    inSchedule: plant.plant.inWateringSchedule,
                    notes: plant.plant.notes ?? '',
                    frequency: plant.schedule?.frequency.toDouble() ?? 7,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddPlantScreen(form: plantForm),
                    ),
                  );
                },
                child: const Text("edit plant"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
