import 'package:aeygiffarine/state/my_service.dart';
import 'package:aeygiffarine/state/register.dart';
import 'package:aeygiffarine/utility/normal_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String user, password;
  bool statusRedEye = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MyService(),
              ),
              (route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.0,
            colors: <Color>[Colors.white, Colors.lightBlueAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLogo(),
                buildAppName(),
                buildUser(),
                buildPassword(),
                buildLogin(),
                buildTextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton buildTextButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          ),
        );
      },
      child: Text('New Register'),
    );
  }

  Container buildLogin() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบทุกช่อง');
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 250,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        keyboardType: TextInputType.emailAddress,
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
        obscureText: statusRedEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: statusRedEye
                ? Icon(Icons.remove_red_eye)
                : Icon(Icons.remove_red_eye_outlined),
            onPressed: () {
              setState(() {
                statusRedEye = !statusRedEye;
              });
            },
          ),
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Text buildAppName() => Text(
        'Aey Giffarine',
        style: GoogleFonts.caveat(
          textStyle: TextStyle(
            color: Colors.blue,
            fontSize: 40,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      );

  Container buildLogo() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: 120,
      child: Image.asset('images/logo.png'),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: password)
          .then(
            (value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyService(),
                ),
                (route) => false),
          )
          .catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }
}
