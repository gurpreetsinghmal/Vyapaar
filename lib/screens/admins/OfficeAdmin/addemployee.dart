import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/employee.dart';
import 'package:http/http.dart' as http;


class AddEmployee extends StatefulWidget {
  final String? officeid;
  AddEmployee({this.officeid, Key? key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  String sex = 'M';
  TextEditingController controllerEmpname = TextEditingController();
  TextEditingController controllerMobile = TextEditingController();
  TextEditingController controllerDob = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerCurrhrprice = TextEditingController();
  TextEditingController controllerCurrShifthour =
      TextEditingController(text: "8");
  TextEditingController controllerOvertimerate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text("Add New Employee")),
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
                        controller: controllerEmpname,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 25,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().isEmpty) return "Invalid Name";

                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Employee Name",
                            labelText: 'Employee Name'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controllerMobile,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().length != 10) {
                            return "Invalid Mobile Number";
                          }

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
                        readOnly: true,
                        controller: controllerDob,
                        decoration: InputDecoration(
                          labelText: "Date of birth (yyyy-mm-dd)",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 60),
                                  lastDate: DateTime.now())
                              .then((selectedDate) {
                            if (selectedDate != null) {
                              controllerDob.text =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter date.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                  value: 'M',
                                  groupValue: sex,
                                  onChanged: (val) {
                                    setState(() {
                                      sex = val.toString();
                                    });
                                  }),
                              Text(
                                "Male",
                                style: GoogleFonts.poppins(),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: 'F',
                                  groupValue: sex,
                                  onChanged: (String? val) {
                                    setState(() {
                                      sex = val.toString();
                                    });
                                  }),
                              Text(
                                "Female",
                                style: GoogleFonts.poppins(),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: 'T',
                                  groupValue: sex,
                                  onChanged: (String? val) {
                                    setState(() {
                                      sex = val.toString();
                                    });
                                  }),
                              Text(
                                "TransGender",
                                style: GoogleFonts.poppins(),
                              )
                            ],
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: controllerAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlign: TextAlign.start,
                        maxLength: 80,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().isEmpty) {
                            return "Invalid Address";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "House/Landmark/Town/City",
                            labelText: 'Current Address'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controllerCurrhrprice,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 4,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().length == 0) {
                            return "Invalid Current Hour Price";
                          }

                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Current Hour Price",
                            labelText: 'Current Hour Price'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controllerCurrShifthour,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 2,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().length == 0) {
                            return "Invalid Current Shift Hour";
                          }

                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Current Shift Hour",
                            labelText: 'Current Shift Hour'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controllerOvertimerate,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 4,
                        validator: (value) {
                          if (value == null) return "Error";
                          if (value.trim().length == 0) {
                            return "Invalid Overtime Price";
                          }

                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Overtime Price",
                            labelText: 'Overtime Price'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final isValid = _formkey.currentState?.validate();

                          if (isValid == true) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Employee e = Employee(
                                id: "test",
                                officeid: widget.officeid.toString(),
                                name: controllerEmpname.text,
                                mobile: controllerMobile.text,
                                dob: controllerDob.text,
                                gender: sex.toString(),
                                address: controllerAddress.text,
                                curr_hr_price: controllerCurrhrprice.text,
                                curr_shift_hour: controllerCurrShifthour.text,
                                overtimerate: controllerOvertimerate.text,
                                pin: Random().nextInt(9998) + 1,
                                isactive: 1);

                            savenewEmployee(context, e);
                            _formkey.currentState?.reset();
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
                          "Add Employee",
                          style: GoogleFonts.poppins(),
                        ),
                      )
                    ],
                  ),
                )),
          )),
    );
  }

  showalertdialog(BuildContext context, dynamic data) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            title: Text(
              data["id"],
              style: GoogleFonts.poppins(color: secondaryColor),
            ),
            backgroundColor: whiteColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 50,
                  color: primaryColor,
                ),
                Text(
                  data["msg"],
                  style: GoogleFonts.poppins(color: primaryColor),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Secret Pin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  data["pin"],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          ));

  savenewEmployee(BuildContext c, Employee e) async {
    Uri url = Uri.parse(URL_CREATE_NEW_EMPLOYEE);
    var res = await http.post(url, body: {
      "cnemp": "cnemp",
      "empid": e.id.toString(),
      "officeid": e.officeid.toString(),
      "pic": e.pic.toString(),
      "name": e.name.toString(),
      "mobile": e.mobile.toString(),
      "dob": e.dob.toString(),
      "gender": e.gender.toString(),
      "address": e.address.toString(),
      "curr_hr_price": e.curr_hr_price.toString(),
      "curr_shift_hour": e.curr_shift_hour.toString(),
      "advance": e.advance.toString(),
      "last_sal_date": e.last_sal_date.toString(),
      "overtimerate": e.overtimerate.toString(),
      "pin": e.pin.toString(),
      "isactive": e.isactive.toString()
    });
    if (res.statusCode == 200) {
      //print(res.body);
      try {
        var x = jsonDecode(res.body);
        var data = x["data"];
        if (data["code"] != "200") {
          MyToast.Error(data["msg"]);
        } else {
          MyToast.Success(data["msg"]);
          showalertdialog(c, data);
        }
      } catch (e) {
        MyToast.Error("Something went wrong. Exception Occured");
      }
    }
  }
}
