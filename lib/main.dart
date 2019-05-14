import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'splash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  //ANALYTICS
  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      new FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Decision Maker',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: new Splash(analytics, observer),
    );
  }
}
