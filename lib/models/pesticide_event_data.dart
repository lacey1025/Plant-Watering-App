import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/accessory_data.dart';

class PesticideEventData {
  final Event event;
  final List<AccessoryData> accessories;

  PesticideEventData({required this.event, required this.accessories});
}
