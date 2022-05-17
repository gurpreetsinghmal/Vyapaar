class Office {
  String id;
  String orgid;
  String hodname;
  String contact;
  String location;
  int pin;
  int isactive;

  Office({
    required this.id,
    required this.orgid,
    required this.hodname,
    required this.contact,
    required this.location,
    required this.pin,
    required this.isactive,
  });

  static Office tojson(Map<String, dynamic> map) => Office(
      id: map["id"],
      orgid: map["orgid"],
      hodname: map["hodname"],
      contact: map["contact"],
      location: map["location"],
      pin: map["pin"],
      isactive: map["isactive"]);
}
