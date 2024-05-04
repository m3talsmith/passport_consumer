import 'dart:io';

import 'package:flutter/material.dart';
import 'package:passport/storage/storage.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage().initialize();
  await Preferences().initialize();

  runApp(const GeneralApp());
}
