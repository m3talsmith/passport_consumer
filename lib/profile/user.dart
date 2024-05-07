import 'dart:convert';

import 'package:passport/storage/storage.dart';

class User {
  User({this.displayName});

  String? displayName;

  User.fromMap(Map<String, dynamic> data) {
    displayName = data['display_name'];
  }

  Map<String, dynamic> toMap() => {
    'display_name': displayName,
  };

  save() => Storage().userFile.writeAsStringSync(jsonEncode(toMap()));
}