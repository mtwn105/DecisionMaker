import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_page.dart';
import 'decision.dart';
import 'intro_page.dart';
import 'login_or_signup.dart';
import 'options_page.dart';
import 'decision_row.dart';
import 'settings_page.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class DecisionsPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  DecisionsPage(this.analytics, this.observer);
  @override
  _DecisionsPageState createState() => _DecisionsPageState(analytics, observer);
}

class _DecisionsPageState extends State<DecisionsPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _DecisionsPageState(this.analytics, this.observer);
  String uid = "";
  CollectionReference collectionReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentScreen();
    populateDecisions();
  }

  Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Decision Page',
    );
  }

  void populateDecisions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = (prefs.getString('uid') ?? "");
      collectionReference =
          Firestore.instance.collection("DecisionData/" + uid + "/decisions");
    });
    print(uid);
  }

  Future<Null> logEvent(String name) async {
    await analytics.logEvent(
      name: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          logEvent("new_decision");
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new OptionPage(analytics,observer)),
          );
        },
      ),
      appBar: new AppBar(
        title: new Text("Decision Maker"),
        leading: null,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new SettingsPage(analytics,observer)),
              );
            },
          ),
        ],
      ),
      body: new StreamBuilder(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot == null)
            return new Center(child: new CircularProgressIndicator());
          if (snapshot.data.documents.length < 1) {
            return new Center(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.add_circle,
                  size: 125.0,
                  color: Colors.grey,
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new Text(
                  "Start by making a decision by tapping '+' button!",
                  textAlign: TextAlign.center,
                )
              ],
            ));
          }
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot decision) {
              Decision paraDecision = new Decision(decision['options'],
                  decision['ratings'], decision['sumRatings']);
              return DecisionRow(paraDecision);
              // return new Text("Hey");
            }).toList(),
          );
        },
      ),
    );
  }
}
