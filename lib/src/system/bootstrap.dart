import 'dart:math';

import 'package:expense_tracker/src/outer_layer/notifications/notification_client.dart';
import 'package:expense_tracker/src/system/di/injection.dart' as di;
import 'package:expense_tracker/src/system/di/injection.dart';
import 'package:expense_tracker/src/system/scale_binding.dart';
import 'package:expense_tracker/src/system/utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

Future<void> bootstrap() async {
  // Proportional scaling for different screen sizes
  // This also initializes the WidgetsBinding
  ScaleUiBinding.ensureInitialized(scaleResolver: _calculateScaleFactor);

  // Initialize essential dependencies
  await di.init();
  await sl<INotificationClient>().initialize();
  Bloc.observer = TalkerBlocObserver(talker: talker);
}

/// Calculate the scale factor based on the screen size
double _calculateScaleFactor(Size size) {
  const double designWidth = 402;
  const double designHeight = 874;

  final widthScale = size.width / designWidth;
  final heightScale = size.height / designHeight;

  // Use min to ensure content fits.
  // Clamp(0.75, 1.05):
  // - 0.75: Supports iPhone SE (height constraint ~0.74) & small Androids.
  // - 1.05: Prevents excessive zooming on large screens
  // (Nothing Phone, S25 Ultra), keeping UI crisp.
  return min(widthScale, heightScale).clamp(0.75, 1.05);
}
