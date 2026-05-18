import 'package:expense_tracker/src/app.dart';
import 'package:expense_tracker/src/system/bootstrap.dart';
import 'package:flutter/material.dart';

void main() async {
  await bootstrap();
  runApp(const App());
}
