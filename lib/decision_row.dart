import 'package:flutter/material.dart';

import 'decision.dart';
import 'decision_view.dart';

class DecisionRow extends StatefulWidget {
  final Decision decision;
  DecisionRow(this.decision);
  @override
  _DecisionRowState createState() => _DecisionRowState();
}

class _DecisionRowState extends State<DecisionRow> {
  Map<dynamic, dynamic> options = new Map();
  Map<dynamic, dynamic> ratings = new Map();
  int sumRatings;
  List<Widget> decisionlist = new List();
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.deepPurple,
    Colors.green,
    Colors.indigo
  ];
  String title = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    options = widget.decision.options;
    ratings = widget.decision.ratings;
    sumRatings = widget.decision.sumRatings;
    title = options[0.toString()].toString();
    for (int i = 0; i < options.length; i++) {
      decisionlist.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: new Container(
          padding: const EdgeInsets.all(2.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(12.0),
            color: colors[i % 6],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Center(
                child: new Text(
              options[i.toString()].toString(),
              style: new TextStyle(fontSize: 18.0, color: Colors.white),
            )),
          ),
        ),
      ));
      if (i != options.length - 1) {
        decisionlist.add(Padding(
          padding: const EdgeInsets.fromLTRB(8.0,2.0,8.0,2.0),
          child: new Container(
            width: 40.0,
            padding: EdgeInsets.all(2.0),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Center(
                  child: new Text("vs",
                style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueAccent,
                  fontWeight: FontWeight.bold
                    ),
              )),
            ),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new DecisionView(widget.decision)),
            );
          },
          child: Material(
            elevation: 2.0,
            color: new Color(0xffeeeeee),
            borderRadius: new BorderRadius.circular(12.0),
            child: new Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 48.0,
                    child: Center(
                      child: new ListView(
                        scrollDirection: Axis.horizontal,
                        children: decisionlist,
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
