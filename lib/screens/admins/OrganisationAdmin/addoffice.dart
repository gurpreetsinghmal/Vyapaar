// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:mera_vyapaar/basecomponents/colors.dart';

import '../../../basecomponents/constants.dart';

class Addoffice extends StatefulWidget {
  final String orgid;
  const Addoffice({required this.orgid, Key? key}) : super(key: key);

  @override
  State<Addoffice> createState() => _AddofficeState();
}

class _AddofficeState extends State<Addoffice> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controllerHod = TextEditingController();
    TextEditingController controllerContact = TextEditingController();
    TextEditingController controllerLocation = TextEditingController();
    String? hodname, contact, location;
    var _formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text("Add Office")),
      body: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controllerHod,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 25,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().isEmpty) return "Invalid Name";
                          hodname = value.trim();
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Office HOD Name",
                            labelText: 'HOD Name'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controllerContact,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().length != 10) {
                            return "Invalid Mobile Number";
                          }
                          contact = value.trim();
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Mobile",
                            labelText: 'Mobile'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controllerLocation,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlign: TextAlign.start,
                        maxLength: 80,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().isEmpty) {
                            return "Invalid Address";
                          }

                          location = value.trim();
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Office Location",
                            labelText: 'Address'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final isValid = _formkey.currentState?.validate();

                          if (isValid == true) {
                            FocusManager.instance.primaryFocus?.unfocus();

                            saveoffice(context, widget.orgid, hodname, contact,
                                location);
                            setState(() {});
                          } else {
                            MyToast.Error("Errors in input fields");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          "Add Office",
                          style: GoogleFonts.poppins(),
                        ),
                      )
                    ],
                  ),
                )),
          )),
    );
  }

  void showalertdialog(BuildContext context, dynamic data) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            title: Text(
              data["officeid"],
              style: GoogleFonts.poppins(color: secondaryColor),
            ),
            backgroundColor: whiteColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data["msg"],
                  style: GoogleFonts.poppins(color: primaryColor),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "HOD Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(data["hodname"]),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Contact",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(data["contact"]),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(data["location"]),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Ok"))
            ],
          ));

  saveoffice(BuildContext c, String orgid, String? hodname, String? contact,
      String? location) async {
    Uri url = Uri.parse(URL_CREATE_NEW_OFFICE);
    var res = await http.post(url, body: {
      "orgid": orgid,
      "hodname": hodname,
      "contact": contact,
      "location": location
    });
    if (res.statusCode == 200) {
      var x = jsonDecode(res.body);
      var data = x["data"];
      if (data["code"] != "200") {
        MyToast.Error(data["msg"]);
      } else {
        MyToast.Success(data["msg"]);
        showalertdialog(c, data);
      }
    }
  }
}
