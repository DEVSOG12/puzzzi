import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzzi/widgets/auth.dart';
import 'package:puzzzi/widgets/game/page.dart';
import 'package:puzzzi/widgets/src/Widget/signupContainer.dart';
import 'package:puzzzi/widgets/src/signin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isloading = false;
  final username = TextEditingController();
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 20, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameWidget() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            controller: username,
            decoration: InputDecoration(
              
              // hintText: 'Enter your full name',
              labelText: 'Name',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(226, 222, 211, 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailWidget() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            controller: emailcontroller,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              // hintText: 'Enter your full name',
              labelText: 'Email',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(226, 222, 211, 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordWidget() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormField(
            controller: passwordcontroller,
            obscureText: true,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                  color: Color.fromRGBO(226, 222, 211, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(226, 222, 211, 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          //  setState(() {
          isloading = true;
          // });
          UserCredential? user = await AuthService().signup(
              email: emailcontroller.text,
              password: passwordcontroller.text,
              username: username.text);

          if (user != null) {
            // setState(() {
            isloading = false;
            // });
            log(user.toString());
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => GamePage()));
          }
          if (user == null) {
            // setState(() {
            isloading = false;
            // });
            log("Error");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error")));
          }
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            '',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1.6),
          ),
          SizedBox.fromSize(
            size: Size.square(70.0), // button width and height
            child: ClipOval(
              child: Material(
                color: Color.fromRGBO(76, 81, 93, 1),
                child: Icon(Icons.arrow_forward,
                    color: Colors.white), // button color
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _createLoginLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage())),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
                height: MediaQuery.of(context).size.height * 1,
                child: SignUpContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: height * .4),
                        _nameWidget(),
                        SizedBox(height: 20),
                        _emailWidget(),
                        SizedBox(height: 20),
                        _passwordWidget(),
                        SizedBox(height: 80),
                        _submitButton(),
                        SizedBox(height: height * .050),
                        _createLoginLabel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(top: 60, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
