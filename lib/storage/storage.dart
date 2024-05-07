import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypton/crypton.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/user.dart';

class Storage {
  static Storage? _storage;
  Directory? _localDir;
  late String privateKey;
  late String publicKey;
  late User user;

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
    if (!credentials.existsSync()) {
      credentials.createSync(recursive: true);
      _createMasterKey();
    }
    if (!_masterKeyExists()) _createMasterKey();
    _loadMasterKey();
    if (!_userExists()) _createDefaultUser();
    _loadUser();
  }

  bool _userExists() {
    return File(join(data.path, 'user.json')).existsSync();
  }

  _createDefaultUser() {
    user = User();
    var userData = jsonEncode(user.toMap());
    if (!userFile.existsSync()) userFile.createSync(recursive: true);
    userFile.writeAsStringSync(userData);
  }

  _loadUser() {
    var userData = jsonDecode(userFile.readAsStringSync());
    user = User.fromMap(userData);
  }

  bool _masterKeyExists() {
    return (File(join(credentials.path, 'master.key')).existsSync() &&
        File(join(credentials.path, 'master.pub')).existsSync());
  }

  _createMasterKey() {
    final privKeyPath = join(credentials.path, 'master.key');
    final privKey = File(privKeyPath);
    if (!privKey.existsSync()) privKey.createSync();

    final pubKeyPath = join(credentials.path, 'master.pub');
    final pubKey = File(pubKeyPath);
    if (!pubKey.existsSync()) pubKey.createSync();

    final keyPair = ECKeypair.fromRandom();
    privKey.writeAsStringSync(keyPair.privateKey.toString());
    pubKey.writeAsStringSync(keyPair.publicKey.toString());
  }

  _loadMasterKey() {
    var privKey = File(join(credentials.path, 'master.key'));
    var pubKey = File(join(credentials.path, 'master.pub'));

    privateKey = privKey.readAsStringSync();
    publicKey = pubKey.readAsStringSync();
  }

  String _backupData() {
    var filename = join(local.path, 'passport.zip');
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(data, filename: filename);
    return filename;
  }

  _restoreData(Uint8List buffer) {
    if (data.existsSync()) data.deleteSync(recursive: true);
    if (!credentials.existsSync()) credentials.createSync(recursive: true);

    final archive = ZipDecoder().decodeBytes(buffer);
    var key = archive.findFile(join('credentials','master.key'));
    var pub = archive.findFile(join('credentials','master.pub'));
    if (key == null || pub == null) return;

    File(join(credentials.path, 'master.key')).createSync();
    File(join(credentials.path, 'master.pub')).createSync();

    final keyStream = OutputFileStream(join(credentials.path, 'master.key'));
    key.writeContent(keyStream);

    final pubStream = OutputFileStream(join(credentials.path, 'master.pub'));
    pub.writeContent(pubStream);

    final userData = archive.findFile('user.json');
    userFile.createSync();
    final userStream = OutputFileStream(userFile.path);
    if (userData != null) userData.writeContent(userStream);

    _init();
  }

  clearData() {
    data.deleteSync(recursive: true);
    _init();
  }

  initialize() async {
    return _init();
  }

  Directory get local => _localDir ?? Directory('');

  Directory get data => Directory(join(local.path, 'data'));

  File get userFile => File(join(data.path, 'user.json'));

  Directory get credentials => Directory(join(data.path, 'credentials'));

  String get backup => _backupData();

  restore(Uint8List data) => _restoreData(data);
}

class Preferences {
  static Preferences? _preferences;
  SharedPreferences? _prefs;

  factory Preferences() {
    _preferences ??= Preferences._internal();
    return _preferences!;
  }

  Preferences._internal() {
    _init();
  }

  _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  initialize() async {
    return _init();
  }

  bool get darkMode =>
      _prefs != null ? _prefs!.getBool('darkMode') ?? false : false;

  setDarkMode(bool mode) {
    _prefs ??= _init();
    _prefs!.setBool('darkMode', mode);
  }
}
