import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'about_page.dart';
import 'intro_page.dart';
import 'login_or_signup.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  SettingsPage(this.analytics, this.observer);

  @override
  _SettingsPageState createState() => _SettingsPageState(analytics, observer);
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _SettingsPageState(this.analytics, this.observer);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentScreen();
  }

  Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Settings Page',
    );
  }

  Future<Null> logEvent(String name) async {
    await analytics.logEvent(
      name: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Container(
        color: Colors.transparent,
        child: new ListView(
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                logEvent("tutorial_viewed");
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new IntroPage(analytics, observer)),
                );
              },
              child: new InkWell(
                splashColor: Colors.blue,
                child: new ListTile(
                  title: new Text(
                    "Tutorial",
                  ),
                  subtitle: new Text("Learn how to use app."),
                ),
              ),
            ),
            new Container(
              height: 0.25,
              color: Colors.grey,
            ),
            new GestureDetector(
              onTap: () async {
                logEvent("rate_app_clicked");
                const url =
                    'https://play.google.com/store/apps/details?id=jai.shriram.decisionmaker';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: new InkWell(
                child: new ListTile(
                  title: new Text(
                    "Rate",
                  ),
                  subtitle: new Text("Rate the app on Google Play Store."),
                ),
              ),
            ),
            new Container(
              height: 0.25,
              color: Colors.grey,
            ),
            new GestureDetector(
              onTap: () {
                logEvent("about_page_opened");
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new AboutPage()),
                );
              },
              child: new InkWell(
                child: new ListTile(
                  title: new Text(
                    "About",
                  ),
                  subtitle: new Text("About the app and developer."),
                ),
              ),
            ),
            new Container(
              height: 0.25,
              color: Colors.grey,
            ),
            new GestureDetector(
              onTap: () async {
                logEvent("signed_out");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                auth.signOut();
                prefs.setBool('loggedin', false);
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new LoginPage(analytics, observer)),
                );
              },
              child: new InkWell(
                child: new ListTile(
                  title: new Text(
                    "Sign out",
                  ),
                  subtitle: new Text("Sign out from the app."),
                ),
              ),
            ),
            new Container(
              height: 0.25,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
