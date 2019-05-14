library flutter_walkthrough;

import 'package:flutter/material.dart';

import 'walkthrough.dart';

/// A IntroScreen Class.
///
///

class IntroScreen extends StatefulWidget {
  final List<Walkthrough> walkthroughList;
  final MaterialPageRoute pageRoute;
  IntroScreen(this.walkthroughList, this.pageRoute);

  void skipPage(BuildContext context) {
    Navigator.pushReplacement(context, pageRoute);
  }

  @override
  IntroScreenState createState() {
    return new IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == widget.walkthroughList.length - 1) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
    //  padding: const EdgeInsets.s(10.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
         new Container(height: 20.0,),
          new Expanded(
            flex: 3,
            child: new PageView(
              children: widget.walkthroughList,
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FlatButton(
                child: new Text(lastPage ? "" : "SKIP",
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                onPressed: () => lastPage
                    ? null
                    : widget.skipPage(
                        context,
                      ),
              ),
              new FlatButton(
                child: new Text(lastPage ? "GOT IT" : "NEXT",
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                onPressed: () => lastPage
                    ? widget.skipPage(context)
                    : controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn),
              ),
            ],
          )
        ],
      ),
    );
  }
}
