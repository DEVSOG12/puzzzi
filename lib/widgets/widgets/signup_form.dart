import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/auth.dart';
import 'package:puzzzi/widgets/game/page.dart';
import 'package:puzzzi/widgets/login_page.dart';

class SignUpForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();

  final paddingTopForm,
      fontSizeTextField,
      fontSizeTextFormField,
      spaceBetweenFields,
      iconFormSize;
  final spaceBetweenFieldAndButton,
      widthButton,
      fontSizeButton,
      fontSizeForgotPassword,
      fontSizeSnackBar,
      errorFormMessage;

  SignUpForm(
      this.paddingTopForm,
      this.fontSizeTextField,
      this.fontSizeTextFormField,
      this.spaceBetweenFields,
      this.iconFormSize,
      this.spaceBetweenFieldAndButton,
      this.widthButton,
      this.fontSizeButton,
      this.fontSizeForgotPassword,
      this.fontSizeSnackBar,
      this.errorFormMessage);

  @override
  Widget build(BuildContext context) {
    bool isloading = false;
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;

    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(
                left: widthSize * 0.05,
                right: widthSize * 0.05,
                top: heightSize * paddingTopForm),
            child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Username',
                      style: TextStyle(
                          fontSize: widthSize * fontSizeTextField,
                          fontFamily: 'Poppins',
                          color: Colors.white))),
              TextFormField(
                  controller: usernamecontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Empty';
                    }
                  },
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    labelStyle: TextStyle(color: Colors.white),
                    errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: widthSize * errorFormMessage),
                    prefixIcon: Icon(
                      Icons.person,
                      size: widthSize * iconFormSize,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontSize: fontSizeTextFormField)),
              SizedBox(height: heightSize * spaceBetweenFields),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email',
                      style: TextStyle(
                          fontSize: widthSize * fontSizeTextField,
                          fontFamily: 'Poppins',
                          color: Colors.white))),
              TextFormField(
                  controller: emailcontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Empty';
                    }
                  },
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    labelStyle: TextStyle(color: Colors.white),
                    errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: widthSize * errorFormMessage),
                    prefixIcon: Icon(
                      Icons.person,
                      size: widthSize * iconFormSize,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontSize: fontSizeTextFormField)),
              SizedBox(height: heightSize * spaceBetweenFields),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password',
                      style: TextStyle(
                          fontSize: widthSize * fontSizeTextField,
                          fontFamily: 'Poppins',
                          color: Colors.white))),
              TextFormField(
                  controller: passwordcontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Empty';
                    }
                  },
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    labelStyle: TextStyle(color: Colors.white),
                    errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: widthSize * errorFormMessage),
                    prefixIcon: Icon(
                      Icons.lock,
                      size: widthSize * iconFormSize,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontSize: fontSizeTextFormField)),
              SizedBox(height: heightSize * spaceBetweenFieldAndButton),
              isloading
                  ? CircularProgressIndicator()
                  : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.fromLTRB(widthButton, 15, widthButton, 15),
                      color: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          //  setState(() {
                          isloading = true;
                          // });
                          UserCredential? user = await AuthService().signup(
                              email: emailcontroller.text,
                              password: passwordcontroller.text,
                              username: usernamecontroller.text);

                          if (user != null) {
                            // setState(() {
                            isloading = false;
                            // });
                            log(user.toString());
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => GamePage()));
                          }
                          if (user == null) {
                            // setState(() {
                            isloading = false;
                            // });
                            log("Error");
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Error")));
                          }
                        }
                      },
                      child: Text('ENTER',
                          style: TextStyle(
                              fontSize: widthSize * fontSizeButton,
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(41, 187, 255, 1)))),
              SizedBox(height: heightSize * 0.01),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoginPage(issignup: false)));
                },
                child: Text('Already have an account? Sign In',
                    style: TextStyle(
                        fontSize: widthSize * fontSizeForgotPassword,
                        fontFamily: 'Poppins',
                        color: Colors.white)),
              )
            ])));
  }
}
