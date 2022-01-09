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

  String getMessageFromErrorCode(error) {
    switch (error) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
        break;
      default:
        return "Login failed. Please try again.";
        break;
    }
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          setState(() {
            isloading = true;
          });
          dynamic user = await AuthService().signup(
              email: emailcontroller.text,
              password: passwordcontroller.text,
              username: username.text);

          if (user is UserCredential) {
            if ((user).user != null) {
              setState(() {
                isloading = false;
              });

              log(user.toString());
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => GamePage()));
            }
          }
          if (user! is! UserCredential) {
            setState(() {
              isloading = false;
            });
            // log("Error : ${getMessageFromErrorCode(user)}");
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error:  ${user.toString()}")));
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
                child: isloading
                    ? CircularProgressIndicator()
                    : Icon(Icons.arrow_forward,
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
