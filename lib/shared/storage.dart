import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Storage? _storage;
  Directory? _localDir;

  factory Storage() {
    _storage ??= Storage._internal();
    return _storage!;
  }

  Storage._internal() {
    _init();
  }

  _init() async {
    _localDir = await getApplicationSupportDirectory();
    if (!local.existsSync()) local.createSync(recursive: true);
    if (!data.existsSync()) data.createSync(recursive: true);
    if (!credentials.existsSync()) credentials.createSync(recursive: true);
  }

  Directory get local => _localDir ?? Directory('');
  Directory get data => Directory(join(local.path, 'data'));
  Directory get credentials => Directory(join(local.path, 'credentials'));
}

class Preferences {
  static Preferences? _preferences;
  SharedPreferences? _prefs;

  factory Preferences() {
    _preferences ??= Preferences._internal();
    return _preferences!;
  }
  
  Preferences._internal() {
    _initPrefs();
  }
  
  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get darkMode => _prefs != null ? _prefs!.getBool('darkMode') ?? false : false;
  setDarkMode(bool mode) {
    _prefs ??= _initPrefs();
    _prefs!.setBool('darkMode', mode);
  }
}