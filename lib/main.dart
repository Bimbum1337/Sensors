import 'package:flutter/material.dart';
import 'package:untitled5/screens/app_pref.dart';

import 'app.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  runApp(MyApp());
}
