import 'dart:io';
import 'dart:math';

import 'package:aeygiffarine/models/post_model.dart';
import 'package:aeygiffarine/models/user_model.dart';
import 'package:aeygiffarine/utility/normal_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File file;
  String timePost, titlePost, detailPost, urlImage, uidPost;
  bool statusProcess = true; //true not show Process

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findTime();
  }

  Future<Null> findTime() async {
    DateTime dateTime = DateTime.now();
    print('datetime ==>> $dateTime');
    setState(() {
      timePost = DateFormat('dd/MMM/yyyy HH:mm').format(dateTime);
    });
    print('timepost ==>>$timePost');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildImage(context),
            buildText(),
            buildPostTitle(context),
            buildPostDetail(context),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: statusProcess ? SizedBox() : CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (file == null) {
          normalDialog(context,
              'No Image ? Please Choose Image by Click Camera or Gallary');
        } else if (titlePost == null ||
            titlePost.isEmpty ||
            detailPost == null ||
            detailPost.isEmpty) {
          normalDialog(context, 'Have Space ? Please Fill Every Blank');
        } else {
          setState(() {
            statusProcess = false;
            uploadAndInsertData();
          });
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Widget buildText() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(timePost == null ? 'Time' : 'Time:$timePost'),
      );

  Container buildPostDetail(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      width: MediaQuery.of(context).size.width - 100,
      child: TextField(
        onChanged: (value) => detailPost = value.trim(),
        decoration: InputDecoration(
          labelText: 'Type Your Post:',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPostTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      width: MediaQuery.of(context).size.width - 100,
      child: TextField(
        onChanged: (value) => titlePost = value.trim(),
        decoration: InputDecoration(
          labelText: 'Title Post:',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      await ImagePicker()
          .getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      )
          .then((value) {
        file = File(value.path);
        findTime();
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
                color: Colors.blue,
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
                color: Colors.blue,
              ),
              onPressed: () {
                chooseImage(ImageSource.gallery);
              }),
        ],
      ),
    );
  }

  Future<Null> uploadAndInsertData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid ==>> $uid');

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) async {
          UserModel userModel = UserModel.fromMap(event.data());
          String namePost = userModel.name;

          int i = Random().nextInt(1000000);
          String nameFile = '$uid$i.jpg';
          print('nameFile ==>> $nameFile');

          FirebaseStorage storage = FirebaseStorage.instance;
          var refer = storage.ref().child('post/$nameFile');
          UploadTask task = refer.putFile(file);

          await task.whenComplete(() async {
            String urlImage = await refer.getDownloadURL();
            print('Upload Success urlImage ==>>$urlImage');

            PostModel model = PostModel(
                title: titlePost,
                detail: detailPost,
                uidPost: uid,
                timePost: timePost,
                urlImage: urlImage,
                namePost: namePost);

            Map<String, dynamic> data = model.toMap();
            await FirebaseFirestore.instance
                .collection('post')
                .doc()
                .set(data)
                .then(
                  (value) => Navigator.pop(context),
                );
          });
        });
      });
    });
  }
}
