import 'package:aeygiffarine/models/user_model.dart';
import 'package:aeygiffarine/utility/normal_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  double lat, lng;
  String name, user, password;

  @override
  void initState() {
    super.initState();
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

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 250,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.face),
          labelText: 'Name :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 250,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.face),
          labelText: 'User :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 250,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                buildName(),
                buildUser(),
                buildPassword(),
                buildMap(context),
              ],
            ),
          ),
          buildElevatedButton(),
        ],
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

  Column buildElevatedButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton.icon(
            onPressed: () {
              print('name = $name ,user = $user ,password = $password');
              if (name == null ||
                  name.isEmpty ||
                  user == null ||
                  user.isEmpty ||
                  password == null ||
                  password.isEmpty) {
                normalDialog(context, 'กรุณากรอก ทุกช่องด้วยนะคะ');
              } else {
                registerAndInsertData();
              }
            },
            icon: Icon(Icons.cloud_upload),
            label: Text('Register'),
          ),
        ),
      ],
    );
  }

  Future<Null> registerAndInsertData() async {
    await Firebase.initializeApp().then((value) async {
      print('#### Initial Success ####');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: password)
          .then((value) async {
        print('Success Register');
        await FirebaseAuth.instance.authStateChanges().listen((event) async {
          String uid = event.uid;
          print('uid = $uid');
          UserModel model = UserModel(
              name: name,
              email: user,
              password: password,
              lat: lat.toString(),
              lng: lng.toString());
          Map<String, dynamic> data = model.toMap();

          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .set(data)
              .then(
                (value) => Navigator.pop(context),
              );
        });
      }).catchError((error) {
        normalDialog(context, error.message);
      });
    });
  }
}
