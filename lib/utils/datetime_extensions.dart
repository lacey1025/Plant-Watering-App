extension DateTimeHelpers on DateTime {
  String formatDate(bool isLong) {
    final date = this;
    final months = [];
    if (isLong) {
      months.addAll([
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ]);
    } else {
      months.addAll([
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ]);
    }
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String daysBeforeString(int daysSincePrev) {
    if (daysSincePrev <= 0) {
      return "0 days";
    }

    DateTime earlier = subtract(Duration(days: daysSincePrev));
    DateTime later = this;

    if (later.isBefore(earlier)) {
      final tmp = earlier;
      earlier = later;
      later = tmp;
    }

    int years = later.year - earlier.year;
    int months = later.month - earlier.month;
    int days = later.day - earlier.day;

    if (days < 0) {
      final prevMonth = DateTime(later.year, later.month, 0);
      days += prevMonth.day;
      months -= 1;
    }

    if (months < 0) {
      months += 12;
      years -= 1;
    }

    final parts = <String>[];
    if (years > 0) parts.add("$years ${years == 1 ? 'year' : 'years'}");
    if (months > 0) parts.add("$months ${months == 1 ? 'month' : 'months'}");
    if (days > 0) parts.add("$days ${days == 1 ? 'day' : 'days'}");

    if (parts.isEmpty) return "0 days";
    return parts.join(", ");
  }

  String dateTimeToDateString() {
    final date = this;
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime dateStringToDateTime(String dateString) {
    return DateTime.parse(dateString);
  }

  static DateTime getNowTruncated() {
    final now = DateTime.now();
    return (DateTime(now.year, now.month, now.day));
  }
}
