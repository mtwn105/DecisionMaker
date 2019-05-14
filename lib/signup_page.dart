import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'decisions_page.dart';
import 'login_or_signup.dart';

class SignUpPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  SignUpPage(this.analytics, this.observer);

  @override
  _SignUpPageState createState() => _SignUpPageState(analytics, observer);
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _SignUpPageState(this.analytics, this.observer);

  TextEditingController emailtc = new TextEditingController();
  TextEditingController passwordtc = new TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentScreen();
  }

  Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Sign Up Page',
    );
  }

  Future<Null> logEvent(String name, String uid) async {
    await analytics.logEvent(name: name, parameters: <String, dynamic>{
      'uid': uid,
    });
  }

  void handleSignUp() async {
    if (emailtc.text.length < 1 ||
        passwordtc.text.length < 1 ||
        !emailtc.text.contains("@")) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Invalid Details."),
      ));
    } else if (passwordtc.text.length < 8) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Enter atleast 8 character password."),
      ));
    } else {
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailtc.text, password: passwordtc.text)
          .whenComplete(() {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("User already registered. Please Login"),
        ));
      });

      logEvent("signed_up", user.uid);

      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new LoginPage(analytics, observer)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 100.0,
      child: Image.asset('assets/image/decision-making.png'),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailtc,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordtc,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: handleSignUp,
          color: Colors.lightBlueAccent,
          child: Text('Sign Up', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            signUpButton,
          ],
        ),
      ),
    );
  }
}
