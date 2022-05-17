import 'dart:convert';
import 'dart:typed_data';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:mera_vyapaar/Widgets/EmployeeCard.dart';
import 'package:mera_vyapaar/Widgets/Mydialogue.dart';
import 'package:mera_vyapaar/Widgets/Search.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/basecomponents/dbhelper.dart';
import 'package:mera_vyapaar/models/attend.dart';
import 'package:mera_vyapaar/models/employee.dart';
import 'package:mera_vyapaar/models/office.dart';

import 'package:http/http.dart' as http;
import 'package:mera_vyapaar/screens/employees/markattendance.dart';
import 'package:mera_vyapaar/screens/employees/uploadprofile.dart';

import '../../basecomponents/Myfunc.dart';

class EmployeeDashboard extends StatefulWidget {
  EmployeeDashboard({Key? key}) : super(key: key);

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  String query = '';
  List<Attendence> all_attend=[];
  List<Attendence> reqSqnc_attend=[];
  final dbhelper=DatabaseHelper.instance;
  isconnected () async{
    bool Connected =await DataConnectionChecker().hasConnection;
    if(Connected)
      {
        if(reqSqnc_attend.length>0)
          {
             int count=await syncdataOnline(reqSqnc_attend,context);
             if(count>0)
             {MyToast.Success("$count records Sync Successfully");
             getallattend(null);
             }
             else
             MyToast.Error("No records Sync");
          }
      }
  }

  getallattend(String? d) async{

    //get_custom_attendence_specdate
    var alllist=await dbhelper.get_custom_attendence_specdate(d??DateTime.now().toString());

    List<Attendence> list=[];
    List<Attendence> newlist=[];

    for(var i in alllist)
    {
      var a=Attendence.fromJson(i);
      list.add(a);
      if(a.sync=="0")
        newlist.add(a);

    }
    setState(() {
      all_attend= list;
      reqSqnc_attend=newlist;
    });

    print("reqsync:0"+reqSqnc_attend.length.toString());
    if(reqSqnc_attend.isNotEmpty) {
      isconnected();
    }
  }

  Future<List<Map<String,dynamic>>> get_att_count_ondate(String date) async
  {
    List<Map<String,dynamic>> l=[];
    Map<String,dynamic> x={};
    //one week before
    DateTime seed=DateTime.now().subtract(Duration(days: 0));
    for(int i=0;i<=6;i++)
      {
        x= await DatabaseHelper.instance.get_custom_attendence(d:seed.subtract(Duration(days: i)).toString());
        l.add(x);
      }
    return l;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getallattend(null);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> empdet =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return WillPopScope(
      onWillPop: () async {
        final result =
            await exitappdialogue(context, "Do you want to exit App");
        return result ?? false;
      },
      child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: whiteColor,
                      child: empdet["emp"]["pic"] != null
                          ? Container(
                              child: ClipOval(
                                child: Image(
                                  width: 70,
                                  height: 70,
                                  fit:BoxFit.cover,
                                  image: MemoryImage(

                                      base64Decode(empdet["emp"]["pic"]!)),
                                ),
                              ),
                              // backgroundImage: image,
                            )
                          : CircleAvatar(
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
                    accountName:
                        Text(empdet["emp"]["name"].toString().toUpperCase()),
                    accountEmail:
                        Text("Office Id : " + empdet["emp"]["officeid"])),
                ListTile(
                    leading: Icon(Icons.key), title: Text(empdet["emp"]["id"])),
                ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(empdet["emp"]["contact"])),
                ListTile(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadProfilepic(empdet["emp"]["id"]),),
                      );
                    } ,
                    leading: Icon(Icons.image),
                    title: Text("Upload Pic")),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("powered by Technominds",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            color: secondaryColor,
                            fontSize: 15,
                          ))),
                    ),
                  ),
                )
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Employee Dashboard "),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  final result =
                      await exitappdialogue(context, "Do you want to Logout");
                  bool go = result ?? false;
                  if (go) Navigator.pushReplacementNamed(context, "/login");
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Markattedance(empcode: empdet["emp"]["id"],)),
              ).then((value) {
                setState(() {
                      getallattend(null);
                });
              });
            },
            child: Icon(Icons.location_on),
          ),
          body: Column(

            children: [
              SizedBox(
                height: 70,
                child: FutureBuilder<List<Map<String,dynamic>>>(
                  future: get_att_count_ondate(DateTime.now().toString()),
                  builder: (BuildContext context, AsyncSnapshot<List<Map<String,dynamic>>> snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext c,int index){
                        return InkWell(
                          onTap: () async{
                            getallattend(snapshot.data![index]["date"].toString());


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(5)

                              ),
                              margin: EdgeInsets.all(5),
                              child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Text(snapshot.data![index]["count"].toString(),
                                  style: TextStyle(fontSize: 20),),
                                SizedBox(height: 5,),
                                Text(get_formated_onlydate_full(snapshot.data![index]["date"].toString())),

                              ],
                            ),
                          )),
                        );
                      });


                    }
                    else
                    return Container();
                  },
                ),

              ),
              all_attend.isEmpty?Expanded(
                child: Container(
                   alignment: Alignment.center,

                    child: Text("No Attendence marked")),
              ):Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:all_attend.length,
                  itemBuilder:(BuildContext c,int index){
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: 10,bottom: 10),
                    title: Text(get_formated_date_full(string_to_datetime(all_attend[index].capdate))),
                    trailing:all_attend[index].sync=="1"?Icon(Icons.done):Icon(Icons.sync) ,
                    leading:CircleAvatar(
                      backgroundColor: secondaryColor,
                      radius: 30,
                      //backgroundColor: whiteColor,
                      child: ClipOval(
                        child: Image(
                          image: MemoryImage(base64Decode(all_attend[index].image)),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // backgroundImage: image,
                    )
                   ,
                    onLongPress: (){
                      showDialog(
                        context: context,
                        //barrierDismissible: false,
                        builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.zero,
                            child: all_attend[index].image==null
                                ? Icon(
                              Icons.person,
                              size: 120,
                              color: whiteColor,
                            )
                             : Image.memory(base64Decode(all_attend[index].image),width: 100,),),
                      );

                    },
                  ),
                );
            }),
              ),]
          )),
    );
  }

  Future<List<Employee>> fetchemployeedetails(String offficeid) async {
    List<Employee> emplist = [];
    print("Online request fetchemployeedetails");
    Uri url = Uri.parse(URL_FETCH_EMPLOYEE_DETAILS);
    var res = await http.post(url, body: {
      "officeid": offficeid,
    });
    if (res.statusCode == 200) {
      var x = jsonDecode(res.body);
      var data = x["data"];

      if (data["code"] != "200") {
        MyToast.Error(data["msg"]);
        return data["msg"];
      } else {
        var a = data["0"];

        for (var temp in a) {
          Employee o = Employee(
              id: temp["empid"].toString(),
              officeid: temp["officeid"],
              pic: temp["pic"],
              dob: temp["dob"],
              curr_hr_price: temp["curr_hr_price"],
              curr_shift_hour: temp["curr_shift_hour"],
              gender: temp["gender"],
              advance: temp["advance"],
              last_sal_date: temp["last_sal_date"],
              overtimerate: temp["overtimerate"],
              name: temp["name"],
              mobile: temp["mobile"],
              address: temp["address"],
              pin: int.parse(temp["pin"]),
              isactive: int.parse(temp["isactive"]));
          emplist.add(o);
        }

        //MyToast.Success(a.length);

      }
    }
    return emplist;
  }

  Future<bool?> exitappdialogue(BuildContext context, String s) async =>
      showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(s),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: secondaryColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("No")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Yes")),
                ],
              ));
}

Future <int> syncdataOnline(List<Attendence> list,BuildContext context) async{
  int syncdone=0;
  MyDialogue(msg: "Syncing ${list.length} records online...", c: context).showLoaderDialog(context);
  Uri url = Uri.parse(URL_EMP_ATTENDENCE_SYNC);

  for(int i=0;i<list.length;i++)
    {
      var data=list[i].tojson();
      //print(data.toString());
      var res = await http.post(url, body:data);
      if (res.statusCode == 200) {
        syncdone++;
        final dbhelper=DatabaseHelper.instance;
        data["sync"]="1";
        final id= await dbhelper.update_to_attendence(data);
        print("saving data id: $id");
      }
      else
        {
          print(res.statusCode.toString());
        }
    }
  Navigator.pop(context);

  return syncdone;
}

