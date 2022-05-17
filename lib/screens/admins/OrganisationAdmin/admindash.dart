// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mera_vyapaar/Widgets/Search.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/office.dart';
import 'package:mera_vyapaar/screens/admins/OrganisationAdmin/gridcomponent/alloffice.dart';
import 'addoffice.dart';
import 'package:http/http.dart' as http;
import 'editoffice.dart';


class AdminDashboard extends StatefulWidget {
  AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> orgid =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
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
                  accountName: Text(orgid["org"]["org_name"]),
                  accountEmail:
                      Text(orgid["org"]["email"] ?? "email not available")),
              ListTile(
                  leading: Icon(Icons.key), title: Text(orgid["org"]["id"])),
              ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(orgid["org"]["contact"])),
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
          title: Text("Admin Dashboard "),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Addoffice(
                        orgid: orgid["org"]["id"],
                      )),
            ).then((value) => setState(() {}));
          },
          child: Icon(Icons.add),
        ),
        body: Alloffices(orgid)

    );
  }


}


