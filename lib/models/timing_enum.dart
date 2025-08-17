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
}
