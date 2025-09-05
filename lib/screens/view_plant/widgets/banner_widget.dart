import 'package:flutter/material.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/theme.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key, required this.plant});
  final PlantCardData plant;

  @override
  Widget build(BuildContext context) {
    final status = plant.wateringStatus;
    SelectionColorScheme colors;
    switch (status) {
      case WateringStatus.red:
        colors = SelectionColorScheme.pink;
      case WateringStatus.green:
        colors = SelectionColorScheme.green;
      case WateringStatus.yellow:
        colors = SelectionColorScheme.yellow;
      default:
        colors = SelectionColorScheme.blue;
    }

    return Container(
      width: double.infinity,
      color: colors.primaryColor,
      padding: const EdgeInsets.all(8),
      child: Text(
        plant.daysUntilDueStatus(),
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colors.selectedTextColor),
      ),
    );
  }
}
