import 'package:flutter/material.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/theme.dart';

class NotesCard extends StatelessWidget {
  final PlantCardData plant;
  const NotesCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return FakeBlur(
      borderRadius: BorderRadius.zero,
      overlay: Colors.white54,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plant.plant.notes?.isNotEmpty ?? false)
              Text(
                plant.plant.notes!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.darkTextPink),
              ),
            if (plant.schedule != null)
              Text(
                "Water every ${plant.schedule!.frequency} days",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.darkTextPink),
              ),
          ],
        ),
      ),
    );
  }
}
