import 'dart:convert';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mera_vyapaar/Widgets/EmployeeCard.dart';
import 'package:mera_vyapaar/Widgets/Mydialogue.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/employee.dart';
import 'package:mera_vyapaar/models/usertypes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  String? valchoose;
  int level = 0;
  String mob = "";
  String pin = "";
  List<Usertypes> mylist = [
    Usertypes(type: "Superadmin", level: "0"),
    Usertypes(type: "Organisation Admin", level: "1"),
    Usertypes(type: "Office Admin", level: "2"),
    Usertypes(type: "Employee", level: "3"),
    //Usertypes(type: "Employee2", level: "4"),
  ];
  @override
  Widget build(BuildContext context) {
    final iskeyboardclosed = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!iskeyboardclosed)
                    Column(
                      children: [
                        circularLogo(),
                        branding(),
                      ],
                    ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: whiteColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: [
                        Text("LOGIN",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold))),
                        //onlinedropdown(),
                        offlinedropdown(),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (val) {
                            if (val!.length != 10) {
                              return "Invalid Mobile Number";
                            }
                            if (val.trim().length == 10) {
                              mob = val.toString();
                              //FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter 10 Digit Mobile Number",
                              labelText: 'Mobile No'),
                        ),
                        const SizedBox(height: 10),
                        PinCodeTextField(
                          appContext: context,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          length: 6,
                          onChanged: (v) {},
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              inactiveColor: secondaryColor,
                              activeColor: primaryColor,
                              selectedColor: primaryColor),
                          onCompleted: (v) {
                            pin = v;
                          },
                          validator: (val) {
                            if (val!.length != 6) {
                              return "Invalid Pin";
                            }
                          },
                          hintCharacter: "*",
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            final isValid = _formkey.currentState?.validate();

                            if (isValid == true) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              bool isConnected = await DataConnectionChecker().hasConnection;
                              print(isConnected);
                              if(isConnected==true)
                                {
                                  print("connected");
                                  loginadmin(mob, pin, level, context);
                                  /*
                                  levels
                                  superadmin-0,officeadmin-1,officeadmin-2
                                  employee login-3
                                  */
                                }
                              else if(level>2){
                                print("not connected in employee");
                                //in offline case only valid for employees
                               await checkoffline(mob,pin, context);

                              }
                              else{
                                print("not connected not in employee");
                                MyToast.Error("No Internet Connection");
                              }

                            } else {
                              MyToast.Error("Errors in input fields");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: GoogleFonts.poppins(),
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container branding() {
    return Container(
      height: 20,
      alignment: Alignment.bottomCenter,
      child: Text("powered by Technominds",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            color: whiteColor,
            fontSize: 15,
          ))),
    );
  }

  CircleAvatar circularLogo() {
    return CircleAvatar(
      radius: 85,
      backgroundColor: whiteColor,
      child: CircleAvatar(
        child: Icon(
          Icons.business,
          size: 120,
          //color: Colors.amber[800],
        ),
        radius: 80,
        // backgroundImage: NetworkImage(
        //   "https://images.g2crowd.com/uploads/product/image/social_landscape/social_landscape_cdff6c56af2817b55ebed6f38fa9ecc9/vyapar.png",
        // ),
      ),
    );
  }

  DropdownButtonFormField<String> offlinedropdown() {
    return DropdownButtonFormField<String>(
        validator: (value) => value == null ? 'Select Authority' : null,
        isExpanded: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter 10 Digit Mobile Number",
            labelText: 'Authority'),
        value: valchoose,
        hint: Text("Select Authority"),
        items: mylist
            .map((user) => DropdownMenuItem(
                value: user.level.toUpperCase(),
                child: Text(user.type.toUpperCase())))
            .toList(),
        onChanged: (newval) {
          valchoose = newval.toString();
          setState(() {
            level = int.parse(valchoose ?? "0");
          });
          //MyToast.Success(valchoose.toString());
        });
  }

  // StreamBuilder<List<Usertypes>> onlinedropdown() {
  //   return StreamBuilder<List<Usertypes>>(
  //       stream: fetchusertypes(),
  //       builder: (builder, ss) {
  //         if (ss.hasData) {
  //           final x = ss.data!;
  //           mylist.clear();
  //           for (int i = 0; i < x.length; i++) {
  //             mylist.add(x[i]);
  //           }
  //           return DropdownButtonFormField<String>(
  //               validator: (value) => value == null ? 'Select Authority' : null,
  //               isExpanded: true,
  //               decoration: InputDecoration(
  //                   border: OutlineInputBorder(),
  //                   hintText: "Enter 10 Digit Mobile Number"),
  //               value: valchoose,
  //               hint: Text("Select Authority"),
  //               items: mylist
  //                   .map((user) => DropdownMenuItem(
  //                       value: user.level.toUpperCase(),
  //                       child: Text(user.type.toUpperCase())))
  //                   .toList(),
  //               onChanged: (newval) {
  //                 valchoose = newval.toString();
  //                 setState(() {
  //                   level = int.parse(valchoose ?? "0");
  //                 });
  //                 //MyToast.Success(valchoose.toString());
  //               });
  //         } else
  //           return CircularProgressIndicator();
  //       });
}

Future<void>checkoffline(String contact,String pin,BuildContext context) async{
  MyDialogue(msg: 'Loading Offline...',c: context).showLoaderDialog(context);
  Map<String, dynamic>? newdata = await readpref(context);
  print(newdata!["contact"].toString());
  Navigator.pop(context);
  if(newdata["contact"].toString().contains(contact) && newdata["pin"].toString().contains(pin) )
    Navigator.pushReplacementNamed(context, "/empdash",arguments: {"emp": newdata});
  else
    MyToast.Error("Cant Switch User in Server Offline mode");
}

void loginadmin(String mob, String pin, int level, BuildContext context) async {
  try {
    MyDialogue(msg: "Loading...", c: context).showLoaderDialog(context);
    Uri url = Uri.parse(URL_LOGIN);
    var res = await http
        .post(url, body: {"mob": mob, "pin": pin, "level": level.toString()});
    if (res.statusCode == 200) {
      Map x = jsonDecode(res.body);
      Map data = x["data"];
      //print(data);
      if (data["code"] != "200") {
        MyToast.Error(data["msg"]);
        Navigator.pop(context);
      } else if (data["code"] == "200" && data[mob]["isactive"] == "1") {
        Navigator.pop(context);
        switch (level) {
          case 1:
            Navigator.pushReplacementNamed(context, "/admindash",
                arguments: {"org": data[mob]});
            break;
          case 2:
            Navigator.pushReplacementNamed(context, "/officedash",
                arguments: {"office": data[mob]});
            break;
          case 3:
            savepref(context, data[mob]);
            Navigator.pushReplacementNamed(context, "/empdash",
                arguments: {"emp": data[mob]});
        }
      } else {
        MyToast.Error("User is Disabled");
        Navigator.pop(context);
      }
    } else {
      MyToast.Error("Error " + res.statusCode.toString());
      Navigator.pop(context);
      if (level > 2) {
        print("check offline");

        await checkoffline(mob,pin, context);
      }

    }
  } catch (e) {
    Navigator.pop(context);
    if (level > 2) {
      print("check offline");
      await checkoffline(mob,pin, context);
    }
    else
     { MyToast.Error("Cant Reach Server");
     }

  }
}

void savepref(BuildContext context, Map<String, dynamic> data) async {
  final pref = await SharedPreferences.getInstance();

  final result = pref.setString('vyapaar', jsonEncode(data));
  if (result == null)
    MyToast.Error("Cant Save Data");
  else
    MyToast.Success("Data Sync Successfully");
}

Future<Map<String, dynamic>?> readpref(BuildContext context) async {
  final pref = await SharedPreferences.getInstance();
  Map<String, dynamic> json = Map<String, dynamic>();
  String? x = pref.getString("vyapaar");
  if (x != null) {
    json = jsonDecode(x);
  } else {
    MyToast.Error("Please Sync Device once online");
  }
  return json;
}


// Stream<List<Usertypes>> fetchusertypes() => FirebaseFirestore.instance
//     .collection("mst_usertypes")
//     .snapshots()
//     .map((ss) =>
//         ss.docs.map((records) => Usertypes.fromjson(records.data())).toList());
