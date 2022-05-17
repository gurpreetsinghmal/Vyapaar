// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:mera_vyapaar/Widgets/Mydialogue.dart';
import 'package:mera_vyapaar/basecomponents/Myfunc.dart';
import 'package:mera_vyapaar/basecomponents/colors.dart';
import 'package:mera_vyapaar/basecomponents/dbhelper.dart';

class Markattedance extends StatefulWidget {
  String empcode;
  Markattedance({required this.empcode,Key? key}) : super(key: key);

  @override
  State<Markattedance> createState() => _MarkattedanceState();
}

class _MarkattedanceState extends State<Markattedance> with WidgetsBindingObserver {
  File? _imagefile;
  String? sfile;
  var picker = ImagePicker();
  final Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
 String? _capdate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  Future getimage() async {
    try {
      File? f;
      final i = await picker.pickImage(source: ImageSource.camera);
      if (i!= null) {
        f= File(i.path);
      }
      if(f!=null && _locationData!=null) {
        final size=f.lengthSync()/1024;
        print("Before: $size");
        File compressedFile = await FlutterNativeImage.compressImage(f.absolute.path,
            quality: 100, percentage: 8);
        final csize=compressedFile.lengthSync()/1024;
        print("After: $csize");
        sfile=base64Encode(compressedFile.readAsBytesSync());
        final t= await saveattendence(sfile!,_locationData);
        setState(() {

        _imagefile=compressedFile;

        _capdate=t;
        });
      }

    } catch (e) {
      print("error:"+e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            _imagefile == null
                ? FlutterLogo(
                    size: 160,
                  )
                : ClipOval(
                    child: Image.file(
                    _imagefile!,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  )),
            ElevatedButton(
                onPressed: () async{
                  MyDialogue(msg: "Initializing ", c: context).showLoaderDialog(context);
                  _serviceEnabled = await location.serviceEnabled();

                  if (!_serviceEnabled) {
                    _serviceEnabled = await location.requestService();
                    if (!_serviceEnabled) {
                      return;
                    }
                  }

                  _permissionGranted = await location.hasPermission();
                  if (_permissionGranted == PermissionStatus.denied) {
                    _permissionGranted = await location.requestPermission();
                    if (_permissionGranted != PermissionStatus.granted) {
                      return;
                    }
                  }
                  _locationData = await location.getLocation();


                  if(_locationData!=null) {
                    getimage();
                  }
                  Navigator.pop(context);
                }, child: Text("Capture Selfy")),
            _capdate==null?Container():
            Container(
              margin:EdgeInsets.all(15) ,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(20)
              ),
              padding: EdgeInsets.all(5),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done),
                  SizedBox(width: 15),
                  _capdate!=null?Text(get_formated_date_full(string_to_datetime(_capdate!))):Container()
                ],
              ),
            )

          ],
        ),
      ),
    );
  }


  Future<String?> saveattendence(String sfile, LocationData locationData) async {
      String s=DateTime.now().toString();
      if(sfile==null)
          return null;
      else{
        final dbhelper=DatabaseHelper.instance;
        Map<String ,dynamic> row={
          dbhelper.empcode:widget.empcode,
          dbhelper.image:sfile,
          dbhelper.latitude:locationData.latitude.toString(),
          dbhelper.longitude:locationData.longitude.toString(),
          dbhelper.capdate:s,
          dbhelper.sync:"0"
        };
        final id= await dbhelper.insert_to_attendence(row);
        return id==0?null:s;
      }

  }
}
