import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'criteria_page.dart';

Map<int, String> myOptions = new Map();
bool resetted = false;

class OptionPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  OptionPage(this.analytics, this.observer);
  @override
  _OptionState createState() => new _OptionState(analytics, observer);
}

class _OptionState extends State<OptionPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _OptionState(this.analytics, this.observer);
  int count = 2;

  List<TextEditingController> mTextEditingController;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  void addOption() {
    if (count < 8) {
      setState(() {
        count += 1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    myOptions;
    super.initState();
    setCurrentScreen();
  }

  Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Options Page',
    );
  }

  @override
  Widget build(BuildContext context) {
    //LIST OF ADDING NEW CRITERIA WIDGETS
    List<Widget> children =
        new List.generate(count, (int i) => new SliderWidget(i));

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("Choose Options"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                count = 2;
                myOptions.clear();
                resetted = true;
              });
            },
          ),
          new IconButton(
            icon: new Icon(Icons.done),
            onPressed: () {
              if (!(myOptions.length < 2) &&
                  !(myOptions[0] == null) &&
                  !(myOptions[1] == null)) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new CriteriaPage(myOptions,analytics,observer)),
                );
              } else {
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text("Enter Some Options..."),
                ));
              }
            },
          ),
        ],
      ),
      body: new ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new SizedBox(
            height: 15.0,
          ),
          new Column(
            children: children,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed:
            addOption, //ONPRESS OF FAB COUNT INCREASES ELEMENT GETS ADDED
      ),
    );
  }
}

//NEW WIDGET FOR CRITERIA - TEXT FIELDS ARE HERE
class SliderWidget extends StatefulWidget {
  final int index;

  SliderWidget(this.index);

  @override
  _SliderWidgetState createState() => new _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  Map<int, String> criteria = new Map();
  TextEditingController tc = new TextEditingController();
  double _value = 1.0;

  List<String> imp = [
    "Barely",
    "Very Less",
    "Less",
    "Moderate",
    "Medium",
    "High",
    "Very High",
    "Very Very High",
    "Extreme"
  ];
  bool _isTyping = false;

  String importance = "Barely";
  @override
  Widget build(BuildContext context) {
    if (resetted == true) {
      tc.text = "";
      resetted = false;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new TextField(
            controller: tc,
            onChanged: (String messageText) {
              setState(() {
                _isTyping = messageText.length > 0;
                addToMyOptions();
              });
            },
            style: new TextStyle(color: Colors.black87, fontSize: 14.0),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                labelText: "Option " + (widget.index + 1).toString()),
          ),
        ],
      ),
    );
  }

  void addToMyOptions() async {
    if (_isTyping == true) {
      myOptions[widget.index] = tc.text;
    }
  }
}
