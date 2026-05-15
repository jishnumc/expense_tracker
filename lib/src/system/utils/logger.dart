import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    maxHistoryItems: 100,
    useConsoleLogs: true,
    useHistory: true,
  ),
);
