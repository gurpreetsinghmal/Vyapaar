class Employee {
  String id;
  String officeid;
  String? pic;
  String name;
  String mobile;
  String dob;
  String gender;
  String address;
  String curr_hr_price;
  String curr_shift_hour;
  String? advance;
  String? last_sal_date;
  String? overtimerate;
  int pin;
  int isactive;

  Employee({
    required this.id,
    required this.officeid,
    this.pic,
    required this.name,
    required this.mobile,
    required this.dob,
    required this.gender,
    required this.address,
    required this.curr_hr_price,
    required this.curr_shift_hour,
    this.advance,
    this.last_sal_date,
    this.overtimerate,
    required this.pin,
    required this.isactive,
  });

  static Employee fromjson(Map<String, dynamic> map) => Employee(
      id: map["id"].toString(),
      officeid: map["officeid"].toString(),
      pic: map["pic"].toString(),
      name: map["name"].toString(),
      mobile: map["contact"].toString(),
      dob: map["dob"].toString(),
      gender: map["gender"].toString(),
      address: map["address"].toString(),
      curr_hr_price: map["curr_hr_price"].toString(),
      curr_shift_hour: map["curr_shift_hr"].toString(),
      advance: map["advance"].toString(),
      last_sal_date: map["last_sal_date"].toString(),
      overtimerate: map["overtimerate"].toString(),
      pin: map["pin"] == null ? 0 : int.parse(map["pin"].toString()),
      isactive:
          map["isactive"] == null ? 0 : int.parse(map["isactive"].toString()));

  Map<String, dynamic> tojson() => {
        "id": id,
        "officeid": officeid,
        "pic": pic,
        "name": name,
        "contact": mobile,
        "dob": dob,
        "gender": gender,
        "address": address,
        "curr_hr_price": curr_hr_price,
        "curr_shift_hour": curr_shift_hour,
        "advance": advance,
        "last_sal_date": last_sal_date,
        "overtimerate": overtimerate,
        "pin": pin,
        "isactive": isactive
      };
}
