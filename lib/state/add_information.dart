import 'dart:io';
import 'dart:math';
import 'package:aeygiffarine/models/user_model.dart';
import 'package:aeygiffarine/utility/normal_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddInformation extends StatefulWidget {
  @override
  _AddInformationState createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  File file;
  String urlImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      appBar: AppBar(
        title: Text('Add Picture Info'),
      ),
      body: Column(
        children: [
          buildImage(context),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'No Image ? กรุณาเลือกรูปภาพหรือถ่ายรูปก่อน');
        } else {
          uploadAndUpdateData();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Padding buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 48,
                color: Colors.blue.shade500,
              ),
              onPressed: () {
                chooseImage(ImageSource.camera);
              }),
          Container(
            width: MediaQuery.of(context).size.width - 200,
            height: MediaQuery.of(context).size.width - 200,
            child: file == null
                ? Image.asset('images/image.png')
                : Image.file(file),
          ),
          IconButton(
              icon: Icon(
                Icons.add_photo_alternate,
                size: 48,
                color: Colors.blue.shade500,
              ),
              onPressed: () {
                chooseImage(ImageSource.gallery);
              }),
        ],
      ),
    );
  }

  Future<Null> uploadAndUpdateData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid ==>> $uid');

        int i = Random().nextInt(1000000);
        String nameFile = '$uid$i.jpg';
        print('nameFile ==>> $nameFile');

        FirebaseStorage storage = FirebaseStorage.instance;
        var refer = storage.ref().child('post/$nameFile');
        UploadTask task = refer.putFile(file);

        await task.whenComplete(() async {
          String urlImage = await refer.getDownloadURL();
          print('Upload Success urlImage ==>>$urlImage');

          await FirebaseFirestore.instance.collection('user').doc(uid).update(
              {'urlAvatar': urlImage,'name':'aeyTest'}).then((value) => Navigator.pop(context));
        });
      });
    });
  }
}
