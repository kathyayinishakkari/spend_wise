import 'package:expense_tracker_app/src/app/app.dart';
import 'package:expense_tracker_app/src/core/services/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = await bootstrap();
  runApp(UncontrolledProviderScope(container: container, child: const ExpenseApp()));
}
