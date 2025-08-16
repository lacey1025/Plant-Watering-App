class AccessoryData {
  final int id;
  final String type;
  final String name;
  final double? strength;

  AccessoryData({
    required this.id,
    required this.type,
    required this.name,
    this.strength,
  });
}
