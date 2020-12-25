import 'package:aeygiffarine/models/user_model.dart';
import 'package:aeygiffarine/state/authen.dart';
import 'package:aeygiffarine/state/ebook.dart';
import 'package:aeygiffarine/state/information.dart';
import 'package:aeygiffarine/state/show_list_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  UserModel userModel;

  Widget currentWidget = ShowListPost();

  String title = 'Show List Post';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid ==> $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
            print('name ==> ${userModel.name},email ==>${userModel.email}');
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: buildDrawer(),
      body: currentWidget,
    );
  }

  Drawer buildDrawer() => Drawer(
        child: Stack(
          children: [
            buildSignOut(),
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListTileListPost(),
                Divider(),
                buildListTileInformation(),
                Divider(),
                buildListTileEbook(),
                Divider(),
              ],
            ),
          ],
        ),
      );

  ListTile buildListTileListPost() {
    return ListTile(
      leading: Icon(
        Icons.view_list,
        size: 40,
        color: Colors.green,
      ),
      title: Text('Show Lost Post'),
      subtitle: Text('แสดง Post ทั้งหมดที่มีในฐานข้อมูล'),
      onTap: () {
        setState(() {
          currentWidget = ShowListPost();
          title = 'Show List Post';
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileInformation() {
    return ListTile(
      leading: Icon(
        Icons.account_box,
        size: 40,
        color: Colors.green,
      ),
      title: Text('Information'),
      subtitle: Text('แสดง Information ของคน Login '),
      onTap: () {
        setState(() {
          currentWidget = Information();
          title = 'Information';
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileEbook() {
    return ListTile(
      leading: Icon(
        Icons.book,
        size: 40,
        color: Colors.blue,
      ),
      title: Text('Ebook'),
      subtitle: Text('แสดง Ebook ของคน Login '),
      onTap: () {
        setState(() {
          currentWidget = Ebook();
          title = 'Ebook';
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(
        userModel == null ? 'Name' : userModel.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      accountEmail: Text(
        userModel == null ? 'Email' : userModel.email,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.green.shade300),
          child: ListTile(
            onTap: () async {
              await Firebase.initializeApp().then((value) async {
                await FirebaseAuth.instance.signOut().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Authen(),
                          ),
                          (route) => false),
                    );
              });
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 36,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'คือการออกจาก Account เพื่อ Loging ใหม่',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
