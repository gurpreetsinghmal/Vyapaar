import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/models/user.dart';

class Person extends StatefulWidget {
  Person({Key? key}) : super(key: key);

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  final formkey = GlobalKey<FormState>();
  String firstname = '';
  String mobile = '';
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formkey,
        child: ListView(
            children: [createusername(), createmobile(), createsubmit()]));
  }

  Widget createusername() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter Your Name",
              border: OutlineInputBorder()),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z ]*$")),
          ],
          validator: (value) {
            if (value!.isEmpty || value.contains("@") || value.contains("."))
              return "Invalid Name";
          },
          onSaved: (value) {
            firstname = value!;
          },
        ),
      );

  Widget createmobile() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          maxLength: 10,
          decoration: const InputDecoration(
              labelText: "Mobile",
              hintText: "Enter 10 Digit Mobile Number",
              border: OutlineInputBorder()),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty || value.length != 10 || value.contains(".")) {
              return "Invalid Mobile Number";
            }
          },
          onSaved: (value) {
            mobile = value!;
          },
        ),
      );

  Widget createsubmit() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          final isValid = formkey.currentState?.validate();
          FocusScope.of(context).unfocus();

          if (isValid == null || isValid) {
            formkey.currentState?.save();

            //savenewuser();
          }
        },
        child: Text("Submit"),
      ));

  // void savenewuser() async {
  //   try {
  //     var ref = FirebaseFirestore.instance.collection("users").doc();
  //     User u = User(id: ref.id, name: firstname, mobile: mobile);
  //     await ref.set(u.tojson());

  //     final message = 'New user created: ${ref.id}';
  //     MyToast.Success(message);
  //   } catch (e) {
  //     MyToast.Error(e.toString());
  //   }
  // }
}
