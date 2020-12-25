import 'package:aeygiffarine/models/user_model.dart';
import 'package:aeygiffarine/state/add_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  UserModel userModel;
  double lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readUser();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat = $lat,lng = $lng');
    });
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> readUser() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid Losing ==>>$uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                child: Image.network(userModel.urlAvatar),
              ),
              Text('Name :'),
              userModel == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(userModel.name),
              //buildMap(context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Email :'),
              Text(userModel.email),
            ],
          ),
          buildMap(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddInformation(),
          ),
        ),
        child: Text('+Info'),
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[
      Marker(
          markerId: MarkerId('idUser'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'คุณอยู่ที่นี่',
            snippet: 'lat = $lat, lng = $lng',
          )),
    ].toSet();
  }

  Expanded buildMap(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 64),
        width: MediaQuery.of(context).size.width,
        child: lat == null
            ? buildProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 16,
                ),
                mapType: MapType.normal,
                onMapCreated: (controller) {},
                markers: mySet(),
              ),
      ),
    );
  }

  Center buildProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
