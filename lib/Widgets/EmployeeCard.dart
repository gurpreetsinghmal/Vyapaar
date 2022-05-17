import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/models/employee.dart';
import '../screens/admins/OfficeAdmin/editemployee.dart';

class EmployeeCard extends StatefulWidget {
  Map<String, dynamic> officedet;
  Employee employee;
  EmployeeCard({required this.officedet, required this.employee, Key? key})
      : super(key: key);

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  late Employee o;
  late Map<String, dynamic> officedet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    o = widget.employee;
    officedet = widget.officedet;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Card(
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeDetailCard(
                        officedet: officedet,
                        employee: widget.employee,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            o.pic != null
                                ? Container(
                                  width: 60,height: 60,
                                    child: ClipOval(
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image:
                                            MemoryImage(base64Decode(o.pic!)),
                                      ),
                                    ),
                                    // backgroundImage: image,
                                  )
                                : Container(
                                  width: 60,height: 60,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: primaryColor,
                                    ),
                                    child: ClipOval(
                                      
                                      child: Icon(
                                        Icons.person,
                                        color: whiteColor,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: widget.employee.isactive == 1
                                        ? primaryColor
                                        : secondaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  widget.employee.isactive == 1
                                      ? "Active"
                                      : "Not Active",
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: whiteColor),
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              EmployeeDetailCard.createrow("Employee ID",
                                  widget.employee.id.toUpperCase()),
                              EmployeeDetailCard.createrow(
                                  "Name", widget.employee.name.toUpperCase()),
                              EmployeeDetailCard.createrow("Mobile",
                                  widget.employee.mobile.toUpperCase()),
                              EmployeeDetailCard.createrow(
                                  "Secret Pin", widget.employee.pin.toString()),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEmployee(
                            officedet: officedet,
                            employee: widget.employee,
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.edit)))
          ],
        ));
  }
}

class EmployeeDetailCard extends StatefulWidget {
  Map<String, dynamic> officedet;
  Employee employee;
  EmployeeDetailCard(
      {required this.officedet, required this.employee, Key? key})
      : super(key: key);

  @override
  State<EmployeeDetailCard> createState() => _EmployeeDetailCardState();

  static Widget createrow(String head, String data) {
    TextStyle boldtext = TextStyle(fontWeight: FontWeight.bold);
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              //color: Colors.redAccent,
              width: 140,
              child: Text(
                head,
                style: boldtext,
              ),
            ),
            Text(data),
          ],
        ),
      ],
    );
  }
}

class _EmployeeDetailCardState extends State<EmployeeDetailCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle boldtext = TextStyle(fontWeight: FontWeight.bold);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    child: Column(
                      children: [
                        Containerhead("Personal Section", context,
                            widget.officedet, false),
                        InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                //barrierDismissible: false,
                                builder: (_) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.zero,
                                    child: widget.employee.pic == null
                                        ? Icon(
                                            Icons.person,
                                            size: 120,
                                            color: whiteColor,
                                          )
                                        : Image(
                                            image: MemoryImage(base64Decode(
                                                widget.employee.pic!)),
                                          )),
                              );
                            },
                            child: ShowProfileimage(widget.employee.pic)),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    EmployeeDetailCard.createrow("Name",
                                        widget.employee.name.toUpperCase()),
                                    EmployeeDetailCard.createrow("Mobile",
                                        widget.employee.mobile.toUpperCase()),
                                    EmployeeDetailCard.createrow(
                                        "Dob",
                                        convertDateFromString(
                                            widget.employee.dob)),
                                    EmployeeDetailCard.createrow(
                                        "Gender",
                                        widget.employee.gender == "f"
                                            ? "FEMALE"
                                            : "MALE")
                                  ],
                                ),
                              ]),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Current Address",
                                style: boldtext,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.employee.address.toUpperCase(),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        )

                        // // Padding(
                        //     padding: const EdgeInsets.only(left: 8),
                        //     child: createrow("Address", "ada")),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Containerhead(
                          "Office Section", context, widget.officedet, false),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EmployeeDetailCard.createrow("Employee ID",
                                      widget.employee.id.toUpperCase()),
                                  EmployeeDetailCard.createrow(
                                      "Hour Price",
                                      widget.employee.curr_hr_price
                                          .toUpperCase()),
                                  EmployeeDetailCard.createrow(
                                      "Shift Hour",
                                      widget.employee.curr_shift_hour
                                          .toUpperCase()),
                                  EmployeeDetailCard.createrow("Advance",
                                      widget.employee.advance ?? "NA"),
                                  EmployeeDetailCard.createrow(
                                      "Last Salary Date",
                                      widget.employee.last_sal_date ?? "NA"),
                                  EmployeeDetailCard.createrow("Overtime Rate",
                                      widget.employee.overtimerate ?? "NA"),
                                  EmployeeDetailCard.createrow("Secret Pin",
                                      widget.employee.pin.toString()),
                                  EmployeeDetailCard.createrow(
                                      "Active ",
                                      widget.employee.isactive == 1
                                          ? "Active"
                                          : "Not Active"),
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    String mydate = todayDate.day.toString().padLeft(2, '0') +
        "-" +
        todayDate.month.toString().padLeft(2, '0') +
        "-" +
        todayDate.year.toString();
    return mydate;
  }

  Container Containerhead(String title, BuildContext context,
      Map<String, dynamic> officedet, bool isedit) {
    return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      //     color: secondaryColor),
      width: double.infinity,
      height: 30,
      color: secondaryColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: whiteColor),
            ),
          ),
          // isedit
          //     ? InkWell(
          //         onTap: () {
          //           Navigator.pushReplacement(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => EditEmployee(
          //                 officedet: officedet,
          //                 employee: widget.employee,
          //               ),
          //             ),
          //           );
          //         },
          //         child: Icon(
          //           Icons.edit,
          //           color: primaryColor,
          //         ))
          //     : Container()
        ],
      ),
    );
  }

  Widget ShowProfileimage(String? pic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: pic != null
          ? CircleAvatar(
              radius: 40,
              //backgroundColor: whiteColor,
              child: ClipOval(
                child: Image(
                  image: MemoryImage(base64Decode(widget.employee.pic!)),
                ),
              ),
              // backgroundImage: image,
            )
          : CircleAvatar(
              radius: 40,
              //backgroundColor: whiteColor,
              child: ClipOval(
                child: Icon(
                  Icons.person,
                  color: whiteColor,
                  size: 40,
                ),
              ),
            ),
    );
  }
}
