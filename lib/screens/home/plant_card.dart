import 'package:flutter/material.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/screens/view_plant/view_plant_screen.dart';
import 'package:plant_application/theme.dart';

class PlantCard extends StatelessWidget {
  final PlantCardData plant;
  const PlantCard({super.key, required this.plant});

  SelectionColorScheme _getColorScheme() {
    if (plant.wateringStatus == null) return SelectionColorScheme.blue;
    switch (plant.wateringStatus) {
      case WateringStatus.green:
        return SelectionColorScheme.green;
      case WateringStatus.yellow:
        return SelectionColorScheme.yellow;
      case WateringStatus.red:
        return SelectionColorScheme.pink;
      default:
        return SelectionColorScheme.blue;
    }
  }

  // Color _getTextColor() {
  //   if (plant.wateringStatus == null) return Colors.white;
  //   switch (plant.wateringStatus) {
  //     case WateringStatus.green:
  //       return AppColors.lightTextGreen;
  //     case WateringStatus.yellow:
  //       return AppColors.lightTextYellow;
  //     case WateringStatus.red:
  //       return AppColors.lightTextPink;
  //     default:
  //       return AppColors.lightTextBlue;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String dueDateString = '';
    if (plant.earliestNextWater != null && plant.latestNextWater != null) {
      if (plant.earliestNextWater == plant.latestNextWater) {
        dueDateString =
            '${plant.earliestNextWater!.month}/${plant.earliestNextWater!.day}';
      } else {
        dueDateString =
            '${plant.earliestNextWater!.month}/${plant.earliestNextWater!.day} - ${plant.latestNextWater!.month}/${plant.latestNextWater!.day}';
      }
    }
    final colors = _getColorScheme();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ViewPlant(plantId: plant.plant.id),
          ),
        );
      },
      child: Card(
        color: colors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plant.plant.name,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                  if (plant.plant.inWateringSchedule)
                    Text(
                      plant.daysUntilDueStatus(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.selectedTextColor,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (plant.plant.inWateringSchedule && plant.schedule != null)
                        ? 'water every ${plant.schedule!.frequency} days'
                        : "not in watering schedule",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.selectedTextColor,
                    ),
                  ),
                  if (plant.plant.inWateringSchedule)
                    Text(
                      dueDateString,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.selectedTextColor,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
