import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'decision.dart';

class DecisionView extends StatefulWidget {
  final Decision decision;

  DecisionView(this.decision);

  @override
  _DecisionViewState createState() => _DecisionViewState();
}

class _DecisionViewState extends State<DecisionView> {
  Map<dynamic, dynamic> options = new Map();
  Map<dynamic, dynamic> rating = new Map();
  int sumRatings = 0;
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
    options = widget.decision.options;
    rating = widget.decision.ratings;
    sumRatings = widget.decision.sumRatings;
    ratings = new List.generate(
        options.length, (int i) => int.parse(rating[i.toString()]));

    int maxPosition(List<int> list) {
      int greatestElement = list[0];
      int position = 0;
      for (int i = 0; i < list.length; i++) {
        if (list[i] > greatestElement) {
          greatestElement = list[i];
          position = i;
        }
      }
      return position;
    }

    maxPositionNum = maxPosition(ratings);
  }

  @override
  Widget build(BuildContext context) {
    children = <CircularStackEntry>[
      new CircularStackEntry(new List.generate(
          options.length,
          (int i) => new CircularSegmentEntry(
              int.parse(rating[i.toString()]).ceilToDouble(), colors[i % 10],
              rankKey: options[i.toString()]))),
    ];

    legend = new List.generate(
        options.length,
        (int i) => new Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 0.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: 20.0,
                    width: 20.0,
                    color: colors[i % 10],
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  new Text(
                    options[i.toString()],
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Text(
                    " : " + rating[i.toString()].toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                ],
              ),
            ));
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Results"),
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
                    padding: EdgeInsets.all(8.0),
                  ),
                  new Text(
                    options[maxPositionNum.toString()],
                    style: new TextStyle(
                        color: colors[maxPositionNum],
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                ],
              ),
              new AnimatedCircularChart(
                holeRadius: 70.0,
                holeLabel: options[maxPositionNum.toString()],
                chartType: CircularChartType.Radial,
                size: new Size(400.0, 400.0),
                initialChartData: children,
              ),
              
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: legend,
              ),new Text(
                "(Option : Decision Maker Score)",
                style: new TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
