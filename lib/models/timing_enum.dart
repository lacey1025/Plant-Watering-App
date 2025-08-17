enum Timing {
  early,
  justRight,
  late,
  notSure;

  @override
  String toString() {
    switch (this) {
      case Timing.early:
        return 'Too early';
      case Timing.justRight:
        return 'Just right';
      case Timing.late:
        return 'Too late';
      case Timing.notSure:
        return 'Not sure';
    }
  }

  static Timing? stringToTiming(String? timing) {
    if (timing == null) return null;

    switch (timing) {
      case "early":
        return Timing.early;
      case "just right":
        return Timing.justRight;
      case "late":
        return Timing.late;
      case "not sure":
        return Timing.notSure;
      default:
        return null;
    }
  }

  String? timingToString() {
    final timing = this;

    switch (timing) {
      case Timing.early:
        return "early";
      case Timing.justRight:
        return "just right";
      case Timing.late:
        return "late";
      case Timing.notSure:
        return "not sure";
    }
  }
}
