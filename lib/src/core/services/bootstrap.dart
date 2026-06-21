import 'dart:async';

import 'package:expense_tracker_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:expense_tracker_app/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<ProviderContainer> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    Zone.current.handleUncaughtError(
      details.exception,
      details.stack ?? StackTrace.current,
    );
  };

  await runZonedGuarded(() async {
    await Firebase.initializeApp();
  }, (Object error, StackTrace stackTrace) {
    debugPrint('Bootstrap initialization error: $error');
    debugPrintStack(stackTrace: stackTrace);
  });

  final container = ProviderContainer();

  try {
    await container.read(ensureAnonymousLoginProvider.future);
  } catch (error, stackTrace) {
    debugPrint('Anonymous login bootstrap error: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await container.read(notificationInitializerProvider.future);
  } catch (error, stackTrace) {
    debugPrint('Notification bootstrap error: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  return container;
}