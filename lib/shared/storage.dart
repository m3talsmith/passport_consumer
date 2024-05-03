import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Storage storage = Storage();

class Storage {
  Storage() {
    _init();
  }

  late Directory localDir;
  late SharedPreferences prefs;

  _init() async {
    localDir = await getApplicationSupportDirectory();
    prefs = await SharedPreferences.getInstance();
  }


}