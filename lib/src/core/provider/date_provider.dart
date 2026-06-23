import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currentDateProvider =
Provider<DateTime>((ref) {
  return DateTime.now();
});