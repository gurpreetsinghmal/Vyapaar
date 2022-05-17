class Usertypes {
  String type;
  String level;

  Usertypes({required this.type, required this.level});

  Map<String, dynamic> tojson() => {"type": type, "level": level};

  static Usertypes fromjson(Map<String, dynamic> map) {
    return Usertypes(type: map["type"], level: map["level"]);
  }
}
