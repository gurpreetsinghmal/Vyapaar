import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mera_vyapaar/Widgets/EmployeeCard.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/employee.dart';
import 'package:http/http.dart' as http;
import 'package:mera_vyapaar/screens/admins/OfficeAdmin/addemployee.dart';

import '../../../../Widgets/Search.dart';

class Allemployees extends StatefulWidget {
  Map<String, dynamic> officeid;

  Allemployees(this.officeid);

  @override
  _AllemployeesState createState() => _AllemployeesState();
}

class _AllemployeesState extends State<Allemployees> {
  String query = '';
  late Map<String, dynamic> officeid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    officeid=widget.officeid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Employees",style: GoogleFonts.poppins(),), centerTitle:true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEmployee(
                  officeid: officeid["office"]["id"],
                )),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: fetchemployeedetails(officeid["office"]["id"]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          else if (snapshot.data.length == 0)
            return Center(child: Text("No Record Found"));
          else {
            return Column(
              children: [
                SearchWidget(
                    text: query,
                    onChanged: (q) {
                      setState(() {
                        query = q;
                      });
                    },
                    hintText: 'Search'),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Employee o = snapshot.data[index];

                        if (query == null ||
                            o.name.toLowerCase().contains(query) ||
                            o.mobile.toLowerCase().contains(query) ||
                            o.id.toLowerCase().contains(query)) {
                          return EmployeeCard(
                              officedet: officeid, employee: o);
                          // InkWell(
                          //     onTap: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => EmployeeCard(
                          //               officedet: officeid, employee: o),
                          //         ),
                          //       );
                          //     },
                          //     child: EmployeeCard(
                          //         officedet: officeid, employee: o));
                        } else {
                          return Container();
                        }
                      }),
                ),
              ],
            );
          }
        },
      ),
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
              id: temp["id"].toString(),
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
              mobile: temp["contact"],
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
}
