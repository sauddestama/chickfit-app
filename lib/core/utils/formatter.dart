import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Formatter {
  Formatter._();
  static int stringToInt(String s) {
    s = s.replaceAll('.0000', '');
    return int.parse(s);
  }

  static DateTime stringToDate(String? s) {
    if (s == null) {
      return DateTime(1990);
    }

    s = s.replaceAll('T', ' ');
    s = s.replaceAll('Z', '');

    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(s);
    } catch (_) {
      date = DateTime(1990);
    }

    return date;
  }

  static String dateToString(DateTime d, {String? format, Locale? locale}) {
    final DateFormat dateFormat =
        DateFormat(format ?? 'dd-MMM-yyyy', locale?.toString());
    String dateString = '';
    try {
      dateString = dateFormat.format(d);
    } catch (_) {
      dateString = dateFormat.format(DateTime(1999));
    }

    return dateString;
  }

  static String fullDate(DateTime d, {Locale? locale}) {
    late DateFormat dateFormat;
      dateFormat = DateFormat('dd MMMM yyyy', locale.toString());
    String dateString = '';
    dateString = dateFormat.format(d.toLocal());

    return dateString;
  }

  static DateFormat fullDateFormat(Locale? locale) {
    late DateFormat dateFormat;
    dateFormat = DateFormat('dd MMMM yyyy', locale.toString());


    return dateFormat;
  }

  static String dateToPost(DateTime d) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    String dateString = '';
    try {
      dateString = '${dateFormat.format(d)}T${timeFormat.format(d)}.000Z';
    } catch (_) {
      dateString =
          '${dateFormat.format(DateTime(1999))}T${timeFormat.format(DateTime(1999))}.000Z';
    }

    return dateString;
  }

  static DateTime localToUtc(DateTime d) {
    final DateTime utcTime = d.toUtc();
    return utcTime;
  }

  static DateTime utcToLocal(DateTime d) {
    final DateTime utcDate = DateTime.utc(
      d.year,
      d.month,
      d.day,
      d.hour,
      d.minute,
      d.second,
    );
    final DateTime localTime = utcDate.toLocal();
    return localTime;
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 hari yang lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari yang lalu';
      } else {
        return '${(difference.inDays / 7).floor()} minggu yang lalu';
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 jam yang lalu';
      } else {
        return '${difference.inHours} jam yang lalu';
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 menit yang lalu';
      } else {
        return '${difference.inMinutes} menit yang lalu';
      }
    } else {
      return 'Baru saja';
    }
  }
}
