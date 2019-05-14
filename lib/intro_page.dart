import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'decisions_page.dart';
import 'login_or_signup.dart';
import 'walkthrough.dart';
import 'flutter_walkthrough.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class IntroPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  IntroPage(this.analytics, this.observer);

  @override
  _IntroScreenState createState() => _IntroScreenState(analytics, observer);
}

class _IntroScreenState extends State<IntroPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _IntroScreenState(this.analytics, this.observer);
  //CHECKING USER LOGGED IN
  bool loggedin = false;

  final List<Walkthrough> list = [
    Walkthrough(
      title: "Life is Full of Decisions...",
      content: "and Decision Maker will help you deal with them",
      imageIcon: 'assets/image/decision-making.png',
    ),
    Walkthrough(
      title: "Options",
      content:
          "Whether you are choosing between different tasks or restaurants or car models...\nPick as many options you like.",
      imageIcon: 'assets/image/options.png',
    ),
    Walkthrough(
      title: "Criteria",
      content:
          "Find characteristics to rate your options. e.g. efficiency or comfort",
      imageIcon: 'assets/image/criteria.png',
    ),
    Walkthrough(
      title: "Rate",
      content:
          "Compare your options and rate each criterion based on how good or bad it performs like Pros and Cons.",
      imageIcon: 'assets/image/rate.png',
    ),
    Walkthrough(
      title: "That's It",
      content: "the app will calculate the best option based on your ratings.",
      imageIcon: 'assets/image/result.png',
    ),
  ];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentScreen();
    loggedIn();
  }

   Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Intro Page',
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroScreen(
      list,
      new MaterialPageRoute(
          builder: (context) =>
              loggedin ? new DecisionsPage(analytics,observer) : new LoginPage(analytics,observer)),
    );
  }
}
