class User {
  String id;
  String name;
  String mobile;

  User({required this.id, required this.name, required this.mobile});

  Map<String, dynamic> tojson() => {"id": id, "name": name, "mobile": mobile};

  static User fromJson(Map<String, dynamic> json) {
    return User(id: json["id"], name: json["name"], mobile: json["mobile"]);
  }
}
