

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location_tmap/screens/home/controller/track_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  TrackController trackController = Get.put(TrackController(),);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Location Tracker"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: () async {

                var status = await Permission.location;
                if(await status.isDenied)
                {
                  await Permission.location.request();
                }

              }, child: Text("Permission"),style: ElevatedButton.styleFrom(backgroundColor: Colors.black),),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                trackController.lat.value = position.latitude;
                trackController.lon.value = position.longitude;
              }, child: Text("Location"),style: ElevatedButton.styleFrom(backgroundColor: Colors.black),),SizedBox(height: 20,),
              Obx(() =>  Text("${trackController.lat.value}")),
              SizedBox(height: 10,),
              Obx(() =>  Text("${trackController.lon.value}")),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: () async{
                List<Placemark> placemarkList = await placemarkFromCoordinates(trackController.lat.value, trackController.lon.value);
                trackController.placeList.value = placemarkList;
              }, child: Text("Track Me"),style: ElevatedButton.styleFrom(backgroundColor: Colors.black),),
              SizedBox(height: 30,),
              Obx(() => Text(trackController.placeList.isEmpty?" ":"${trackController.placeList[0]}")),

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.black,
          onPressed: () {
            Get.toNamed('track');
          },child: Icon(Icons.location_pin),
        ),
      ),
    );
  }
}
