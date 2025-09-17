import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inHours < 24 && now.day == dateTime.day) {
    //Only displays time within the same day
    return DateFormat('HH:mm').format(dateTime.toLocal());
  } else {
    // Displays the full time on older dates
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime.toLocal());
  }
}
