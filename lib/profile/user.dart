import 'dart:convert';

import 'package:passport/storage/storage.dart';

class User {
  User({this.id, this.displayName});

  String? id;
  String? displayName;

  User.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    displayName = data['display_name'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'display_name': displayName,
  };

  save() => Storage().userFile.writeAsStringSync(jsonEncode(toMap()));
}