import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// "27 Apr 2026, 15:30 WIB"
  String get toFormattedDate {
    return '${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(toLocal())} WIB';
  }

  /// "27 Apr 2026"
  String get toFormattedDateOnly {
    return DateFormat('dd MMM yyyy', 'id_ID').format(toLocal());
  }

  /// "15:30"
  String get toFormattedTime {
    return DateFormat('HH:mm', 'id_ID').format(toLocal());
  }

  /// "Baru saja" / "5 menit lalu" / "2 jam lalu" / "Kemarin"
  String get toRelativeTime {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return toFormattedDateOnly;
  }
}

extension StringDateExt on String {
  DateTime get toDateTime => DateTime.parse(this);
  String get toFormattedDate => DateTime.parse(this).toFormattedDate;
}
