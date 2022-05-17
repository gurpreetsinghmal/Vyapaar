class Attendence{

  final String empcode;
  final String image;
  final String latitude;
  final String longitude;
  final String capdate;
  final String sync;

  Attendence({
    required this.empcode,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.capdate,
    required this.sync});
  Attendence.withid({

    required this.empcode,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.capdate,
    required this.sync});



  Map<String,dynamic?> tojson()=>{
      "empcode":empcode,
      "image": image,
      "latitude": latitude,
      "longitude": longitude,
      "capdate": capdate,
      "sync": sync
  };

  static Attendence fromJson(Map<String,dynamic> map){
    return Attendence(
        empcode: map["empcode"].toString(),
        image: map["image"].toString(),
        latitude: map["latitude"].toString(),
        longitude: map["longitude"].toString(),
        capdate: map["capdate"].toString(),
        sync: map["sync"].toString());
  }


}