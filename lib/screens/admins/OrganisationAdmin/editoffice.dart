import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/office.dart';

class Editoffice extends StatefulWidget {
  final Office office_det;
  const Editoffice({required this.office_det, Key? key}) : super(key: key);

  @override
  State<Editoffice> createState() => _EditofficeState();
}

class _EditofficeState extends State<Editoffice> {
  late bool switch_status;
  late Office o;
  late String hodname, contact, location, pin;
  TextEditingController controllerHod = TextEditingController();
  TextEditingController controllerContact = TextEditingController();
  TextEditingController controllerLocation = TextEditingController();
  TextEditingController controllerPin = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    o = widget.office_det;

    controllerHod.text = o.hodname;

    controllerContact.text = o.contact;

    controllerLocation.text = o.location;

    controllerPin.text = o.pin.toString();
    switch_status = o.isactive == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    var _formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text("Edit Office : " + o.id)),
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
                          if (value.trim().length == 0) return "Invalid Name";
                          hodname = value.trim();
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
                          if (value.trim().length != 10)
                            return "Invalid Mobile Number";
                          contact = value.trim();
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
                        maxLength: 50,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().length == 0)
                            return "Invalid Address";

                          location = value.trim();
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Office Location",
                            labelText: 'Address'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controllerPin,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 6,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().length != 6) return "Invalid Pin";
                          pin = value.trim();
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter 6 Digit Pin",
                            labelText: 'Pin'),
                      ),
                      SwitchListTile.adaptive(
                          title: Text("Office Active Status"),
                          activeColor: primaryColor,
                          inactiveThumbColor: secondaryColor,
                          value: switch_status,
                          onChanged: (val) {
                            setState(() {
                              switch_status = val;
                            });
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final isValid = _formkey.currentState?.validate();

                          if (isValid == true) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            //print(pin);
                            updateoffice(context, o.id, hodname, contact,
                                location, pin, switch_status);
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
                          "Update Office",
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
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    data["officeid"],
                    style: GoogleFonts.poppins(color: secondaryColor),
                  ),
                ),
                data["isactive"] == "1"
                    ? Icon(
                        Icons.verified_user,
                        color: primaryColor,
                      )
                    : Icon(
                        Icons.verified_user,
                        color: secondaryColor,
                      ),
              ],
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Login Pin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(data["pin"]),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Ok"))
            ],
          ));

  updateoffice(BuildContext c, String officeid, String? hodname,
      String? contact, String? location, String? pin, bool isactive) async {
    Uri url = Uri.parse(URL_EDIT_OFFICE);
    var res = await http.post(url, body: {
      "id": officeid,
      "hodname": hodname,
      "contact": contact,
      "location": location,
      "pin": pin,
      "isactive": isactive ? "1" : "0"
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
    //print(res.body);
  }
}
