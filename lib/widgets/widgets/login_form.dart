import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/auth.dart';
import 'package:puzzzi/widgets/game/page.dart';
import 'package:puzzzi/widgets/login_page.dart';

class LoginForm extends StatefulWidget {
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

  LoginForm(
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
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

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
                top: heightSize * widget.paddingTopForm),
            child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email',
                      style: TextStyle(
                          fontSize: widthSize * widget.fontSizeTextField,
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
                        fontSize: widthSize * widget.errorFormMessage),
                    prefixIcon: Icon(
                      Icons.person,
                      size: widthSize * widget.iconFormSize,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.fontSizeTextFormField)),
              SizedBox(height: heightSize * widget.spaceBetweenFields),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Senha',
                      style: TextStyle(
                          fontSize: widthSize * widget.fontSizeTextField,
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
                        fontSize: widthSize * widget.errorFormMessage),
                    prefixIcon: Icon(
                      Icons.lock,
                      size: widthSize * widget.iconFormSize,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.fontSizeTextFormField)),
              SizedBox(height: heightSize * widget.spaceBetweenFieldAndButton),
              isloading
                  ? CircularProgressIndicator()
                  : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.fromLTRB(
                          widget.widthButton, 15, widget.widthButton, 15),
                      color: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          UserCredential? user = await AuthService().login(
                              email: emailcontroller.text,
                              password: passwordcontroller.text);

                          if (user != null) {
                            setState(() {
                              isloading = false;
                            });
                            log(user.toString());
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => GamePage()));
                          }
                          if (user == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Error")));
                            log("Error");
                          }
                        }
                      },
                      child: Text('ENTER',
                          style: TextStyle(
                              fontSize: widthSize * widget.fontSizeButton,
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(41, 187, 255, 1)))),
              SizedBox(height: heightSize * 0.01),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoginPage(issignup: true)));
                },
                child: Text('Don\'t Have An Account. Sign Up',
                    style: TextStyle(
                        fontSize: widthSize * widget.fontSizeForgotPassword,
                        fontFamily: 'Poppins',
                        color: Colors.white)),
              )
            ])));
  }
}
