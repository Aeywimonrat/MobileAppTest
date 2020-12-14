import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 250,
      child: TextField(
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
              ],
            ),
          ),
          buildElevatedButton(),
        ],
      ),
    );
  }

  Column buildElevatedButton() {
    return Column(mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.cloud_upload),
              label: Text('Register'),
            ),
      ],
    );
  }
}
