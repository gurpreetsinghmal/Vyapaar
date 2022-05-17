import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mera_vyapaar/Widgets/Search.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/constants.dart';
import 'package:mera_vyapaar/models/office.dart';
import 'package:http/http.dart' as http;

import '../../OrganisationAdmin/editoffice.dart';



class Alloffices extends StatefulWidget {
  Map<String, dynamic> o;

  Alloffices(this.o);

  @override
  _AllofficesState createState() => _AllofficesState();
}

class _AllofficesState extends State<Alloffices> {
  late Map<String, dynamic> orgid;


  Future<List<Office>> fetchofficedetails(String orgid) async {
    List<Office> offices = [];
    print("Online request");
    Uri url = Uri.parse(URL_FETCH_OFFICE_DETAILS);
    var res = await http.post(url, body: {
      "orgid": orgid,
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
          //print(temp);
          Office o = Office(
              id: temp["id"].toString(),
              orgid: temp["orgid"],
              hodname: temp["hodname"],
              contact: temp["contact"],
              location: temp["location"],
              pin: int.parse(temp["pin"]),
              isactive: int.parse(temp["isactive"]));
          offices.add(o);
        }

        //MyToast.Success(a.length);

      }
    }
    return offices;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orgid=widget.o;
  }

  @override
  Widget build(BuildContext context) {
    String query = '';

    return FutureBuilder(
      future: fetchofficedetails(orgid["org"]["id"]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data.length == 0)
          return Center(child: Text("No Record Found"));
        else
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
                      Office o = snapshot.data[index];

                      if (query == null ||
                          o.hodname.toLowerCase().contains(query) ||
                          o.contact.toLowerCase().contains(query) ||
                          o.location.toLowerCase().contains(query) ||
                          o.id.toLowerCase().contains(query))
                        return Card(
                          child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(o.id),
                              children: [
                                ListTile(
                                    onTap: () {
                                      //print(orgid["org"]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Editoffice(
                                                  office_det: o,
                                                )),
                                      ).then((value) => setState(() {}));
                                    },
                                    title: Text(o.hodname),
                                    leading: Icon(Icons.edit),
                                    subtitle:
                                    Text("Pin  " + o.pin.toString()),
                                    trailing: o.isactive == 1
                                        ? Icon(
                                      Icons.verified_user,
                                      color: primaryColor,
                                    )
                                        : Icon(
                                      Icons.verified_user,
                                      color: secondaryColor,
                                    )),
                                Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text("Address : " + o.location),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text("Contact : " + o.contact),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(20)),
                                                padding: EdgeInsets.all(2),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await FlutterPhoneDirectCaller
                                                        .callNumber("+91" +
                                                        o.contact);
                                                    // await launch("tel://+91" + o.contact);
                                                  },
                                                  child: Icon(
                                                    Icons.call,
                                                    size: 15,
                                                    color: whiteColor,
                                                  ),
                                                ))
                                          ],
                                        )
                                      ],
                                    ))
                              ]),
                        );
                      else
                        return Container();
                    }),
              ),
            ],
          );
      },
    );
  }
}