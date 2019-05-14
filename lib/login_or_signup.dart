import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'decisions_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  LoginPage(this.analytics, this.observer);

  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState(analytics, observer);
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _LoginPageState(this.analytics, this.observer);

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
      screenName: 'Login Page',
    );
  }
   Future<Null> logEvent(String name, String uid) async {
    await analytics.logEvent(
      name: name,
      parameters: <String,dynamic>{
        'uid':uid,
      }
    );
  }


  void handleSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedin', true);
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
          .signInWithEmailAndPassword(
              email: emailtc.text, password: passwordtc.text)
          .whenComplete(() {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Invalid Credentials."),
        ));
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("uid", user.uid);

      logEvent("logged_in",user.uid);

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new DecisionsPage(analytics,observer)));
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
      autovalidate: true,
      autofocus: false,
      controller: emailtc,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autovalidate: true,
      autofocus: false,
      obscureText: true,
      controller: passwordtc,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: handleSignIn,
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final signUpLabel = FlatButton(
      child: Text(
        'Sign Up',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => new SignUpPage(analytics,observer)));
      },
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
            SizedBox(height: 12.0),
            password,
            SizedBox(height: 48.0),
            new Text(
              "By logging in you can save the decisions you made using Decision Maker.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            loginButton,
            signUpLabel
          ],
        ),
      ),
    );
  }
}
