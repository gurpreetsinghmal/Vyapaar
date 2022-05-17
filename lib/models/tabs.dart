import 'package:flutter/material.dart';

class Mytabs {
  final IconData icon;
  final String title;
  Mytabs({required this.icon, required this.title});
}

List<Mytabs> listoftabs = [
  Mytabs(icon: Icons.home, title: "Home"),
  Mytabs(icon: Icons.verified_user, title: "Person"),
  Mytabs(icon: Icons.call, title: "Call"),
  Mytabs(icon: Icons.textsms, title: "Test"),
];
