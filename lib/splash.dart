import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'decisions_page.dart';
import 'intro_page.dart';
import 'login_or_signup.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Splash extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Splash(this.analytics, this.observer);

  @override
  _SplashState createState() => _SplashState(analytics,observer);
}

class _SplashState extends State<Splash> {


   final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  
  _SplashState(this.analytics, this.observer);
  //CHECKING USER LOGGED IN
  bool loggedin = false;

  String getId(FirebaseUser user) {
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future loggedIn() async {
    String uid = await auth.currentUser().then(getId);
    if (uid == null) {
      setState(() {
        loggedin = false;
      });
    } else {
      setState(() {
        loggedin = true;
      });
    }
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    loggedin = (prefs.getBool('loggedin') ?? false);

    if (_seen) {
      if (loggedin) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new DecisionsPage(analytics,observer)));
      } else {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new LoginPage(analytics,observer)));
      }
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroPage(analytics,observer)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //loggedIn();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
