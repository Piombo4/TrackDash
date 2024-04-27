import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackdash/model/adapters/activity.g.dart';
import 'package:trackdash/model/adapters/latlng_adapter.dart';
import 'package:trackdash/persistence/app_theme.dart';
import 'package:trackdash/view/HomePage.dart';

import 'model/adapters/datetime_adapter.dart';
import 'model/adapters/duration_adapter.dart';
import 'model/adapters/user_data.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(LatLngAdapter());
  Hive.registerAdapter(DateTimeAdapter());
  Hive.registerAdapter(UserDataAdapter());
  await Hive.openBox('activityBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: app_theme,
      home: const HomePage(),
    );
  }
}
