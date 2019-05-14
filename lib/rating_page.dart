import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'results_page.dart';

Map<int, int> totalRating = new Map();
Map<int, int> criteriaRating = new Map();
List<List<num>> list;

TabController tabController;
makeMatrix(rows, cols, {function}) {
  list = new List<List<num>>.generate(
          rows,
          (i) => new List<num>.generate(
              cols, (j) => function != null ? function(i, j) : 0).toList())
      .toList();
}

List getDataParameters(List dataList, int numberOfFields) {
  var result = [];
  int i = 0;
  while (dataList.length > i) {
    result.add(
        dataList.sublist(i, math.min(i + numberOfFields, dataList.length)));
    i += numberOfFields;
  }
  return result;
}

class RatingPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final Map<int, String> criterias, options;
  final Map<int, int> importance;

  RatingPage(this.options, this.criterias, this.importance, this.analytics,
      this.observer);
  @override
  _RatingPageState createState() => new _RatingPageState(analytics, observer);
}

class _RatingPageState extends State<RatingPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _RatingPageState(this.analytics, this.observer);
  List<Widget> tabsArray = [];
  List<Widget> criteriaArray = [];
  List<Widget> bodyArray = [];

  @override
  void initState() {
    super.initState();
    tabController =
        new TabController(vsync: this, length: widget.options.length);
    makeMatrix(widget.options.length, widget.criterias.length);
    print(list);

    List<Widget> children = new List.generate(
        widget.criterias.length,
        (int i) => new RatingSlider(
            i, widget.criterias[i], widget.importance[i], tabController.index));

    for (var i = 0; i < widget.options.length; i++) {
      tabsArray.add(new Tab(
        text: widget.options[i],
      ));
    }

    for (var i = 0; i < widget.options.length; i++) {
      bodyArray.add(new Container(
        child: new Center(
            child: new Column(
          children: children,
        )),
      ));
    }

    setCurrentScreen();
  }

  Future<Null> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Rating Page',
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.done),
          onPressed: () {
            print(list);
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => new ResultsPage(
                        widget.options,
                        widget.criterias,
                        list,
                        analytics,
                        observer
                      )),
            );
          },
        ),
        appBar: new AppBar(
          title: new Text("Set Ratings"),
          bottom: new TabBar(
            tabs: tabsArray,
            controller: tabController,
          ),
        ),
        body: new TabBarView(
          controller: tabController,
          children: bodyArray,
        ));
  }
}

class RatingSlider extends StatefulWidget {
  final int index;
  final String criterias;
  final int importance;
  final int selectedOption;
  RatingSlider(
      this.index, this.criterias, this.importance, this.selectedOption);

  @override
  _RatingSliderState createState() => new _RatingSliderState();
}

class _RatingSliderState extends State<RatingSlider>
    with AutomaticKeepAliveClientMixin<RatingSlider> {
  double _value = 1.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 36.0, 8.0, 8.0),
      child: new Container(
          child: new Column(
        children: <Widget>[
          new Text(widget.criterias),
          new Slider(
            label: _value.round().toString(),
            min: 1.0,
            max: 10.0,
            divisions: 10,
            value: _value,
            onChanged: (double value) {
              print("TAB:" + tabController.index.toString());
              int rating = value.round() * widget.importance;
              list[tabController.index][widget.index] = rating;
              setState(() {
                _value = value;
              });
            },
          ),
        ],
      )),
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
