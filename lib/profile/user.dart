class User {
  String? displayName;

  User.fromMap(Map<String, dynamic> data) {
    displayName = data['display_name'];
  }

  Map<String, dynamic> toMap() => {
    'display_name': displayName,
  };
}