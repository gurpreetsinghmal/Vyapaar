import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewMaps extends StatefulWidget {
  String lat,lng;
  NewMaps(this.lat,this.lng);
  @override
  _NewMapsState createState() => _NewMapsState();
}

class _NewMapsState extends State<NewMaps> {

  List<Marker> markers=[];
  late double lat,lng;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lat=double.parse(widget.lat);
    lng=double.parse(widget.lng);
    markers.add(Marker(markerId:MarkerId('MyMarker'),draggable: false,position:LatLng(lat,lng),
    //icon: BitmapDescriptor.fromBytes(base64Decode(source))),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("User Location"),),
      body: Container(
        child: GoogleMap(
          markers: Set.from(markers),
          initialCameraPosition:CameraPosition(target: LatLng(lat, lng),
        zoom: 12),
          
        ),
      ),
    );
  }
}
