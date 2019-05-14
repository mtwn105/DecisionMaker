import 'package:flutter/material.dart';

class Walkthrough extends StatefulWidget {
  final title;
  final content;
  final imageIcon;
  final imagecolor;

  Walkthrough(
      {this.title,
      this.content,
      this.imageIcon,
      this.imagecolor = Colors.redAccent});

  @override
  WalkthroughState createState() {
    return new WalkthroughState();
  }
}

class WalkthroughState extends State<Walkthrough>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    animation = new Tween(begin: -250.0, end: 0.0).animate(new CurvedAnimation(
        parent: animationController, curve: Curves.easeInOut));

    animation.addListener(() => setState(() {}));

    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Material(
        animationDuration: new Duration(milliseconds: 500),
        elevation: 2.0,
        borderRadius: new BorderRadius.all(Radius.circular(12.0)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            new SizedBox(height: 20.0,),
            new Transform(
              transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
              child: new Text(
                widget.title,
                softWrap: true,
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            
            new SizedBox(height: 20.0,),
            new Transform(
              transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
              child: new Text(widget.content,
                  softWrap: true,
                  
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black)),
            ),
            new Expanded(flex:1,child: new Container(),),
            new Container(
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imageIcon),
                ),
              ),
              height: 250.0,
              width: 250.0,
            ),
            
            new Expanded(flex:1,child: new Container(),),
          ],
        ),
      ),
    );
  }
}
