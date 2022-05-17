// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mera_vyapaar/Widgets/Call.dart';
import 'package:mera_vyapaar/Widgets/Home.dart';
import 'package:mera_vyapaar/Widgets/Person.dart';
import 'package:mera_vyapaar/Widgets/Test.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/models/tabs.dart';

import 'screens/admins/OrganisationAdmin/admindash.dart';
import 'screens/admins/OfficeAdmin/officedash.dart';
import 'package:mera_vyapaar/screens/commons/login.dart';
import 'package:mera_vyapaar/screens/employees/empdash.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

MaterialApp MyApp() {
  return MaterialApp(
      theme: ThemeData(
        primarySwatch: themecolor,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/login": (context) => LoginPage(),
        "/admindash": (context) => AdminDashboard(),
        "/officedash": (context) => OfficeDashboard(),
        "/empdash": (context) => EmployeeDashboard(),
      },
      home: LoginPage());
}

class MainTabs extends StatelessWidget {
  const MainTabs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listoftabs.length,
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
            title: Text("Apna Vyapaar"),
            bottom: TabBar(
              tabs: listoftabs.map<Widget>((e) {
                return Tab(
                  text: e.title,
                  icon: Icon(e.icon),
                );
              }).toList(),
            )),
        body: TabBarView(
          children: [Home(), Person(), Call(), Test()],
        ),
      ),
    );
  }
}
