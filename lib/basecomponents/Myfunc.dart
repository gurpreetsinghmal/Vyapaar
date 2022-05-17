import 'package:intl/intl.dart';

DateTime string_to_datetime(String data){
  //2022-04-26 16:07:19.356869

  return DateTime.parse(data);
}
String string_to_onlydate(String data){
  //2022-04-26
  if(data.length>10)
  data=data.substring(0,10);

  return data;
}
String get_formated_onlydate_full(String d){
  //23-Apr-2022
  String t=DateFormat('dd-MMM-yyyy').format(string_to_datetime(d));
  return t;
}

String get_formated_date_full(DateTime d){
  //22-April-2022 7:59:07 PM
  String t=DateFormat('dd-MMMM-yyyy').add_jms().format(d);
  return t;
}