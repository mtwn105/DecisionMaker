import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'rating_page.dart';

Map<int, String> myCriteria = new Map();
Map<int, int> myImportance = new Map();
List<String> criterias = new List();
bool resetted = false;

class CriteriaPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final Map<int, String> options;
  CriteriaPage(this.options, this.analytics, this.observer);
  @override
  _CriteriaState createState() => new _CriteriaState(analytics, observer);
}

class _CriteriaState extends State<CriteriaPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _CriteriaState(this.analytics, this.observer);

  int count = 1;

  List<TextEditingController> mTextEditingController;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  void addCriteria() {
    if (count < 9) {
      setState(() {
        count += 1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    myCriteria;
    super.initState();
    setCurrentScreen();
  }

  Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Criteria Page',
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
        title: new Text("Choose Criterias"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                count = 1;
                myCriteria.clear();
                resetted = true;
              });
            },
          ),
          new IconButton(
            icon: new Icon(Icons.done),
            onPressed: () {
              if (!(myCriteria.length < 1)) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RatingPage(
                            widget.options,
                            myCriteria,
                            myImportance,
                            analytics,
                            observer
                          )),
                );
              } else {
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text("Enter some Criterias"),
                ));
              }
            },
          ),
        ],
      ),
      body: new ListView(
        //  mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
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
            addCriteria, //ONPRESS OF FAB COUNT INCREASES ELEMENT GETS ADDED
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
  bool _switchvalue = true;
  List<String> imp = [
    "Barely",
    "Very Very Less",
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
  String relevance = "Barely";
  String highlow = "Higher is better";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myImportance[widget.index] = _value.round();
  }

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
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: new TextField(
                  controller: tc,
                  onChanged: (String messageText) {
                    setState(() {
                      _isTyping = messageText.length > 0;
                      addToMyCriteria();
                    });
                  },
                  style: new TextStyle(color: Colors.black87, fontSize: 14.0),
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelText: "Criteria " + (widget.index + 1).toString()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    new Switch(
                      value: _switchvalue,
                      onChanged: (bool value) {
                        setState(() {
                          _switchvalue = value;

                          if (value) {
                            myImportance[widget.index] = _value.round();
                            print(myImportance[widget.index]);
                            highlow = "Higher is better";
                          } else {
                            myImportance[widget.index] = -1 * _value.round();
                            print(myImportance[widget.index]);
                            highlow = "Lower is better";
                          }
                        });
                      },
                    ),
                    new Text(
                      highlow,
                      style: new TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 5.0),
            child: new Text("Priority: " + relevance,
                style: new TextStyle(
                    fontSize: 12.0, color: Theme.of(context).accentColor)),
          ),
          new Slider(
            label: _value.round().toString(),
            min: 1.0,
            max: 10.0,
            divisions: 10,
            value: _value,
            onChanged: (double value) {
              setState(() {
                _value = value;
                if (_switchvalue) {
                  myImportance[widget.index] = _value.round();
                  print(myImportance[widget.index]);
                } else {
                  myImportance[widget.index] = -1 * _value.round();
                  print(myImportance[widget.index]);
                }
                switch (value.round()) {
                  case 1:
                    relevance = imp[0];
                    break;
                  case 2:
                    relevance = imp[1];
                    break;
                  case 3:
                    relevance = imp[2];
                    break;
                  case 4:
                    relevance = imp[3];
                    break;
                  case 5:
                    relevance = imp[4];
                    break;
                  case 6:
                    relevance = imp[5];
                    break;
                  case 7:
                    relevance = imp[6];
                    break;
                  case 8:
                    relevance = imp[7];
                    break;
                  case 9:
                    relevance = imp[8];
                    break;
                  case 10:
                    relevance = imp[9];
                    break;
                  default:
                    break;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void addToMyCriteria() async {
    if (_isTyping == true) {
      myCriteria[widget.index] = tc.text;
    }
  }
}
