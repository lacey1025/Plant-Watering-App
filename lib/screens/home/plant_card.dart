import 'package:flutter/material.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/screens/view_plant/view_plant_screen.dart';

class PlantCard extends StatelessWidget {
  final PlantCardData plant;
  const PlantCard({super.key, required this.plant});

  Color _getCardColor() {
    if (plant.wateringStatus == null) return Colors.white;
    switch (plant.wateringStatus) {
      case WateringStatus.green:
        return const Color.fromARGB(61, 76, 175, 79);
      case WateringStatus.yellow:
        return const Color.fromARGB(84, 255, 235, 59);
      case WateringStatus.red:
        return const Color.fromARGB(74, 244, 67, 54);
      default:
        return const Color.fromARGB(255, 194, 194, 194);
    }
  }

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
        color: _getCardColor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(plant.plant.name),
                if (plant.plant.inWateringSchedule && plant.schedule != null)
                  Text('Water every ${plant.schedule!.frequency} days'),
              ],
            ),
            Column(
              children: [
                if (plant.plant.inWateringSchedule) ...[
                  Text(plant.daysUntilDueStatus()),
                  Text(dueDateString),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
