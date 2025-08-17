enum EventType {
  watering,
  pesticide,
  repot,
  fertilizer;

  @override
  String toString() {
    switch (this) {
      case EventType.watering:
        return 'watering';
      case EventType.fertilizer:
        return 'fertilizer';
      case EventType.pesticide:
        return 'pesticide';
      case EventType.repot:
        return 'repot';
    }
  }
}
