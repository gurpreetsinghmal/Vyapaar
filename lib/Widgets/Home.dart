import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';

import '../models/user.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
        stream: null,
        builder: (ctx, ss) {
          if (ss.hasError) {
            MyToast.Error(ss.error.toString());
            print("myerror :" + ss.error.toString());
            return Text(ss.error.toString());
          } else if (ss.hasData) {
            final user = ss.data!;

            return user.length > 0
                ? ListView(
                    shrinkWrap: true,
                    children: user.map(buildlist).toList(),
                  )
                : Center(child: Text("No Name Found"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildlist(User e) {
    return ListTile(
      title: Text(e.name),
      onTap: () {
        MyToast.Error(e.mobile);
      },
      leading: CircleAvatar(
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        child: Text(e.name.toString().toUpperCase().substring(0, 1)),
      ),
    );
  }
}

// Stream<List<User>> readuser() => FirebaseFirestore.instance
//     .collection("users")
//     .orderBy("name", descending: true)
//     .snapshots()
//     .map((ss) =>
//         ss.docs.map((records) => User.fromJson(records.data())).toList());
