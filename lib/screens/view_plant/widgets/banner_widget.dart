import 'package:flutter/material.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/theme.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key, required this.plant});
  final PlantCardData plant;

  @override
  Widget build(BuildContext context) {
    final status = plant.wateringStatus;
    Color? color;
    Color? textColor;
    switch (status) {
      case WateringStatus.red:
        color = AppColors.primaryPink;
        textColor = AppColors.lightTextPink;
      case WateringStatus.green:
        color = AppColors.primaryGreen;
        textColor = AppColors.lightTextGreen;
      case WateringStatus.yellow:
        color = AppColors.primaryYellow;
        textColor = AppColors.lightTextYellow;
      default:
        color = Colors.white;
        textColor = AppColors.darkTextBlue;
    }

    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.all(8),
      child: Text(
        plant.daysUntilDueStatus(),
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: textColor),
      ),
    );
  }
}
