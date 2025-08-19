import 'package:flutter/material.dart';
import 'package:plant_application/models/plant_card_data.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key, required this.plant});
  final PlantCardData plant;

  @override
  Widget build(BuildContext context) {
    final status = plant.wateringStatus;
    Color? color;
    switch (status) {
      case WateringStatus.red:
        color = Colors.red[100];
      case WateringStatus.green:
        color = Colors.green[100];
      case WateringStatus.yellow:
        color = Colors.yellow[100];
      default:
        color = Colors.white;
    }

    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.all(8), // text padding only
      child: Text(plant.daysUntilDueStatus(), textAlign: TextAlign.center),
    );
  }
}
