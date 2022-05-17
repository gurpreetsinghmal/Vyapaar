import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mera_vyapaar/Widgets/EmployeeCard.dart';
import 'package:mera_vyapaar/Widgets/Search.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/employee.dart';
import 'package:mera_vyapaar/models/office.dart';

import 'package:http/http.dart' as http;
import 'package:mera_vyapaar/screens/admins/OfficeAdmin/addemployee.dart';
import 'package:mera_vyapaar/screens/admins/OfficeAdmin/gridcomponent/allemployees.dart';
import 'package:mera_vyapaar/screens/admins/OfficeAdmin/gridcomponent/showattemdance.dart';

import 'gridcomponent/allemployees.dart';

class OfficeDashboard extends StatefulWidget {
  OfficeDashboard({Key? key}) : super(key: key);

  @override
  _OfficeDashboardState createState() => _OfficeDashboardState();
}

class _OfficeDashboardState extends State<OfficeDashboard> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> officeid =
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
                      child: Icon(
                        Icons.business,
                        size: 50,
                        color: secondaryColor,
                      ),
                    ),
                    accountName: Text(officeid["office"]["hodname"]),
                    accountEmail: Text(
                        officeid["office"]["email"] ?? "email not available")),
                ListTile(
                    leading: Icon(Icons.key),
                    title: Text(officeid["office"]["id"])),
                ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(officeid["office"]["contact"])),
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
            title: Text("Office Dashboard "),
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

          body: //Allemployees(officeid)
                showgrid(officeid)
      ),
    );
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

class showgrid extends StatelessWidget {
  Map<String, dynamic> officeid;
  showgrid(this.officeid);


  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
    children: [
      InkWell(
        onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Allemployees(officeid)),
          );
        },
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: tintcolor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person,size: 40,color: Colors.white,),
              SizedBox(height: 20),
              Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 15),)
            ],
          ),
        ),
      ),
      InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Showattendance(officeid["office"]["id"])),
          );
        },
        child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: secondaryColor,
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              Icon(Icons.wifi_protected_setup,size: 40,color: Colors.white,),
              SizedBox(height: 20),
              Text("Attendance",style: GoogleFonts.poppins(color: Colors.white,fontSize: 15),)
              ],
              ),
    ),
      ),
    /*
    Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tintcolor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tintcolor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tintcolor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tintcolor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person,size: 50,color: Colors.white,),
            SizedBox(height: 20),
            Text("Employees",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
    */
    ],
    );
  }
}

