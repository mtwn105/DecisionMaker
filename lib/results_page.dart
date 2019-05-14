import 'dart:async';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'decisions_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class ResultsPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final Map<int, String> options, criterias;
  final List<List<num>> list;

  ResultsPage(
      this.options, this.criterias, this.list, this.analytics, this.observer);

  @override
  _ResultsPageState createState() => _ResultsPageState(analytics, observer);
}

class _ResultsPageState extends State<ResultsPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _ResultsPageState(this.analytics, this.observer);

  Map<int, int> rating;
  int sumRating = 0;
  List<CircularStackEntry> children;
  List<Color> colors = [
    Colors.red,
    Colors.lime,
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.green,
    Colors.indigo
  ];
  List<Widget> legend;
  List<int> ratings;
  int maxPositionNum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rating = new Map();
    for (int i = 0; i < widget.list.length; i++) {
      int sum = 0;
      for (int j = 0; j < widget.list[i].length; j++) {
        sum = sum + widget.list[i][j];
      }

      rating[i] = sum;
      //sumRating = sumRating + rating[i];

    }

    for (int i = 0; i < widget.list.length; i++) {
      if (rating[i] < 0) {
        for (int j = 0; j < widget.list.length; j++) {
          rating[j] += 100;
        }
      }

      while (sumRating < rating[i]) {
        sumRating = sumRating + rating[i];
        for (int j = 0; j < widget.list.length; j++) {
          rating[j] += 100;
        }
      }
    }

    ratings = new List.generate(widget.options.length, (int i) => rating[i]);

    int maxPosition(List<int> list) {
      int greatestElement = list[0];
      int position = 0;
      for (int i = 0; i < list.length; i++) {
        if (list[i] > greatestElement) {
          greatestElement = list[i];
          position = i;
        }
      }
      print("POSITION: " + position.toString());
      return position;
    }

    maxPositionNum = maxPosition(ratings);

    logEvent("decision_result");
  }

  Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Results Page',
    );
  }

  Future<Null> logEvent(String name) async {
    await analytics.logEvent(
      name: name,
    );
  }

  void saveToFirebase() async {
    String uid = await auth.currentUser().then((FirebaseUser user) {
      return user.uid.toString();
    });
    final String rand1 = "${new Random().nextInt(100000)}";
    final String rand2 = "${new Random().nextInt(100000)}";
    final String rand3 = "${new Random().nextInt(100000)}";
    final String rand4 = "${new Random().nextInt(100000)}";
    final String random = rand1 + rand2 + rand3 + rand4;
    final DocumentReference documentReference = Firestore.instance
        .document("DecisionData/" + uid + "/decisions/" + random);
    ;

    Map<String, String> options = new Map();
    Map<String, String> ratingString = new Map();
    for (int i = 0; i < widget.options.length; i++) {
      options[i.toString()] = widget.options[i];
      ratingString[i.toString()] = rating[i].toString();
    }

    Map<String, dynamic> data = <String, dynamic>{
      "options": options,
      "ratings": ratingString,
      "sumRatings": sumRating
    };
    documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));

    logEvent("decision_saved");

    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(
            builder: (context) => new DecisionsPage(analytics, observer)),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    print(maxPositionNum);

    children = <CircularStackEntry>[
      new CircularStackEntry(new List.generate(
          widget.options.length,
          (int i) => new CircularSegmentEntry(
              rating[i].ceilToDouble(), colors[i % 10],
              rankKey: widget.options[i]))),
    ];

    legend = new List.generate(
        widget.options.length,
        (int i) => Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 0.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: 14.0,
                    width: 14.0,
                    color: colors[i % 10],
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  new Text(
                    widget.options[i],
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Text(
                    " : " + rating[i].toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                ],
              ),
            ));
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.save),
        onPressed: saveToFirebase,
      ),
      appBar: new AppBar(
        title: new Text("Results"),
        leading: new IconButton(
          tooltip: "New Decision",
          icon: new Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new DecisionsPage(analytics, observer)),
                (Route<dynamic> route) => false);
          },
        ),
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Text(
                    "Best Choice",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.00),
                  ),
                  new Text(
                    widget.options[maxPositionNum],
                    style: new TextStyle(
                        color: colors[maxPositionNum],
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                ],
              ),
              new AnimatedCircularChart(
                holeRadius: 70.0,
                holeLabel: widget.options[maxPositionNum],
                chartType: CircularChartType.Radial,
                size: new Size(400.0, 400.0),
                initialChartData: children,
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: legend,
              ),
              new Text(
                "(Option : Decision Maker Score)",
                style: new TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
