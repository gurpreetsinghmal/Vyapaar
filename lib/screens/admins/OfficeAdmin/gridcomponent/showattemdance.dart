import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mera_vyapaar/Widgets/Mydialogue.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:http/http.dart' as http;

import 'package:mera_vyapaar/screens/admins/OfficeAdmin/newmaps.dart';

import '../../../../Widgets/Toast.dart';
import '../../../../basecomponents/Myfunc.dart';

class Showattendance extends StatefulWidget {
  String officeid;
  Showattendance(this.officeid);
  @override
  _ShowattendanceState createState() => _ShowattendanceState();
}

class _ShowattendanceState extends State<Showattendance> {
  late String officeid;
  List nmap=[];
  late String seldate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    officeid=widget.officeid;
    seldate=DateTime.now().toString();

    getdata();

  }

  getdata() async{

    nmap=await fetchdateattendence(officeid, string_to_onlydate(seldate));

    setState(() {
    });

  }

  Future<List> fetchdateattendence(String officeid,String date) async{
    List nmap=[];
    Uri url = Uri.parse(URL_FETCH_ATTENDANCE_ONDATE);
    var res = await http.post(url, body: {
      "officeid": officeid.toString(),
      "capdate":date.toString()
    });
    if (res.statusCode == 200) {
      try {
        var x = jsonDecode(res.body);
        var data = x["data"];
        if (data["code"] != "200") {
          MyToast.Error(data["msg"]);
        } else {
          nmap= data["0"];
        }
      } catch (e) {
        print(e.toString());
        MyToast.Error("Something went wrong. Exception Occurred");

      }
    }
    return nmap;
  }

  choosedate() async{
    showDatePicker(
        context: context, initialDate: string_to_datetime(seldate),
        firstDate: DateTime(2021),
        lastDate: DateTime.now()).then((date) async {
          seldate=date.toString();
          MyDialogue(c: context,msg:"Getting Data").showLoaderDialog(context);
          await getdata();
          Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance",style: GoogleFonts.poppins(),),centerTitle: true,),
      body: Container(
        child: seldate!=null?Column(

          children: [
            Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(onPressed:(){
                choosedate();
              }, icon:Icon(Icons.calendar_today), label:Text(string_to_onlydate(seldate))),
            ),

            buildtiles(),
          ],
        ):Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  Widget image(String thumbnail) {

    final _byteImage = Base64Decoder().convert(thumbnail);
    Widget image = Image.memory(_byteImage);
    return image;
  }

  buildtiles()
  {

    List<ExpansionTile> et=[];
    for(int t=0;t<nmap.length;t++)
      {
        List temp=nmap[t]??[];
        if(temp.length>0)
        {
          ExpansionTile e = ExpansionTile(
            leading: Container(
              width: 40,height: 40,
              child: nmap[t][0]["pic"]!=null?ClipOval(child: Image.memory(base64Decode(nmap[t][0]["pic"]),fit:BoxFit.cover ,),)
              :CircleAvatar(
                radius: 35,
                backgroundColor: secondaryColor,
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    color: whiteColor,
                    size: 35,
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(nmap[t][0]["name"].toString().toUpperCase()),
              Text(get_formated_date_full(string_to_datetime(nmap[t][0]["capdate"])).substring(11))
              ],
            ),
            children: [
              for(int k = 0; k < temp.length; k++)
                Column(
                  children: [
                    ListTile(
                      onLongPress: (){

                          showDialog(
                            context: context,
                            //barrierDismissible: false,
                            builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.zero,
                                child: Image.network(URL_FETCH_PIC_ATTENDANCE+nmap[t][k]["image"])),
                          );

                      },
                        trailing: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewMaps(nmap[t][k]["latitude"],nmap[t][k]["longitude"])),
                            );
                          },
                          child: Icon(Icons.map),),
                       leading: Image.network(URL_FETCH_PIC_ATTENDANCE+nmap[t][k]["image"]),
                       title:Text(get_formated_date_full(string_to_datetime(nmap[t][k]["capdate"])))),
                  ],
                ),

            ],
          );

          et.add(e);
        }

      }

    return Column(
      children: [
        for(int s=0;s<et.length;s++)
          et[s],
      ],
    );

  }


}
