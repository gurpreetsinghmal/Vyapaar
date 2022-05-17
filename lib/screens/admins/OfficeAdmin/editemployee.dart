import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/employee.dart';
import 'package:http/http.dart' as http;


class EditEmployee extends StatefulWidget {
  Map<String, dynamic> officedet;
  final Employee employee;
  EditEmployee({required this.officedet, required this.employee, Key? key})
      : super(key: key);

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  late Employee emp;
  late String empname, mobile, address, chp, adv, overtime, pin;
  late bool switch_status;
  TextEditingController controllerEmpname = TextEditingController();
  TextEditingController controllerMobile = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerCurrHourPrice = TextEditingController();
  TextEditingController controllerAdvance = TextEditingController();
  TextEditingController controllerOvertimeRate = TextEditingController();
  TextEditingController controllerPin = TextEditingController();
  late Map<String, dynamic> officedet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emp = widget.employee;
    officedet = widget.officedet;
    switch_status = emp.isactive == 1 ? true : false;
    controllerEmpname.text = emp.name;
    controllerMobile.text = emp.mobile;
    controllerAddress.text = emp.address;
    controllerCurrHourPrice.text = emp.curr_hr_price;
    controllerAdvance.text = emp.advance ?? "0";
    controllerOvertimeRate.text = emp.overtimerate ?? "0";
    controllerPin.text = emp.pin.toString();
  }

  @override
  Widget build(BuildContext context) {
    var _formkey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/officedash",
            arguments: officedet);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Edit Employee : " + emp.id)),
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
                            if (value.trim().length == 0) return "Invalid Name";
                            empname = value.trim();
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
                            if (value.trim().length != 10)
                              return "Invalid Mobile Number";
                            mobile = value.trim();
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
                          controller: controllerAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textAlign: TextAlign.start,
                          maxLength: 50,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null) return "Error";
                            if (value.trim().length == 0)
                              return "Invalid Address";

                            address = value.trim();
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
                          controller: controllerCurrHourPrice,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: 4,
                          validator: (value) {
                            if (value == null) return "Error";
                            if (value.trim().length == 0)
                              return "Invalid Price";
                            chp = value.trim();
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
                          controller: controllerAdvance,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: 4,
                          validator: (value) {
                            if (value == null) return "Error";
                            if (value.trim().length == 0)
                              return "Invalid Advance";
                            adv = value.trim();
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Advance",
                              labelText: 'Advance'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: controllerOvertimeRate,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: 4,
                          validator: (value) {
                            if (value == null) return "Error";
                            if (value.trim().length == 0)
                              return "Invalid Overtime Rate";
                            overtime = value.trim();
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Overtime Rate",
                              labelText: 'Overtime Rate'),
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
                            title: Text("Employee Active Status"),
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
                              // print(
                              //     "${emp.empid},$empname, $mobile,$address,$chp,$adv,$overtime, $pin, $switch_status");
                              updateemp(
                                  context,
                                  emp.id,
                                  empname,
                                  mobile,
                                  address,
                                  chp,
                                  adv,
                                  overtime,
                                  pin,
                                  switch_status);
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
                            "Update Employee",
                            style: GoogleFonts.poppins(),
                          ),
                        )
                      ],
                    ),
                  )),
            )),
      ),
    );
  }

  void updateemp(
      BuildContext context,
      String empid,
      String empname,
      String mobile,
      String address,
      String chp,
      String adv,
      String overtime,
      String pin,
      bool switch_status) async {
    Uri url = Uri.parse(URL_EDIT_EMPLOYEE);
    var res = await http.post(url, body: {
      "empid": empid,
      "name": empname,
      "mobile": mobile,
      "address": address,
      "chp": chp,
      "adv": adv,
      "overtime": overtime,
      "pin": pin,
      "isactive": switch_status ? "1" : "0"
    });
    try {
      if (res.statusCode == 200) {
        var x = jsonDecode(res.body);
        var data = x["data"];
        if (data["code"] != "200") {
          MyToast.Error(data["msg"]);
        } else {
          MyToast.Success(data["msg"]);
          await showalertdialog(context, data);
        }
        Navigator.pushReplacementNamed(context, "/officedash",
            arguments: officedet);
      }
    } catch (e) {
      //print(e.toString());
      MyToast.Error("Something went wrong. Exception Occured");
    }
  }

  showalertdialog(BuildContext context, dynamic data) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            title: Text(
              data["empid"],
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
}
