import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:mera_vyapaar/Widgets/Toast.dart';

import '../../basecomponents/constants.dart';

class UploadProfilepic extends StatefulWidget {
  String empdet;
  UploadProfilepic(this.empdet);

  @override
  _UploadProfilepicState createState() => _UploadProfilepicState();
}

class _UploadProfilepicState extends State<UploadProfilepic> {
  late String ownid;
  String status="";
  File? _imagefile;
  String? imagedata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ownid=widget.empdet;
  }

  Future getimage() async {
    try {
      File? f;
      final i = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (i!= null) {
        f= File(i.path);
      }
      if(f!=null) {

        final size=f.lengthSync()/1024;
        print("Before: $size");
        File compressedFile = await FlutterNativeImage.compressImage(f.absolute.path,
            quality: 100, percentage: 10);
        final csize=compressedFile.lengthSync()/1024;
        print("After: $csize");
        imagedata=base64Encode(compressedFile.readAsBytesSync());
        setState(() {
          _imagefile=compressedFile;
        });
      }

    } catch (e) {
      print("error:"+e.toString());
    }
  }


  chooseimage() async{
    getimage();
  }
  Widget showimage(){
    return _imagefile == null
        ? FlutterLogo(
      size: 160,
    )
        : ClipOval(
        child: Image.file(
          _imagefile!,
          height: 160,
          width: 160,
          fit: BoxFit.cover,
        ));
  }
  uploadimage() async{
    if(imagedata!=null) {
      var data = {
        "id": ownid,
        "image": imagedata
      };
      Uri url = Uri.parse(URL_UPDATE_PIC);
      var response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        print("may be");
        print(response.body);
        var j=jsonDecode(response.body);
        MyToast.Success(j["data"]["msg"]);
      }
      else{
        print("gome wrong");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Pic"),),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: chooseimage, child: Text("Choose Image")),
            SizedBox(height: 20),
            showimage(),
            SizedBox(height: 20),
            OutlinedButton(onPressed: uploadimage, child: Text("Upload Image")),
            SizedBox(height: 20),
            Text(status,textAlign: TextAlign.center,style: TextStyle(color:Colors.teal),)
          ],
        ),
      ),
    );
  }
}
