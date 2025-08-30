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

  static EventType? toEvent(String type) {
    switch (type) {
      case "watering":
        return EventType.watering;
      case "fertilizer":
        return EventType.fertilizer;
      case "pesticide":
        return EventType.pesticide;
      case "repot":
        return EventType.repot;
      default:
        return null;
    }
  }
}
