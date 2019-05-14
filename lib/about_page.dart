import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appVersion = "1.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPackageInfo();
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("About"),
      ),
      body: new Stack(
        children: <Widget>[
          ListView(
             padding: const EdgeInsets.only(top:24.0),
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Text(
                            "Decision Maker",
                            style: new TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                          ),
                          Text(
                            "v" + appVersion,
                            style: new TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "By",
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      new Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(75.0),
                            border: new Border.all(
                                color: Theme.of(context).accentColor,
                                width: 4.0)),
                        child: new CircleAvatar(
                          radius: 75.0,
                          backgroundImage: AssetImage("assets/image/dev.png"),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Amit Wani",
                        style: new TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context).accentColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Android Developer".toUpperCase(),
                        style: new TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new IconButton(
                        icon: new Icon(
                          FontAwesomeIcons.facebookF,
                          size: 36.0,
                          color: Colors.indigo,
                        ),
                        onPressed: () async {
                          const url = 'https://www.facebook.com/mtwn1051';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new IconButton(
                        icon: new Icon(
                          FontAwesomeIcons.twitter,
                          color: Colors.lightBlueAccent,
                          size: 36.0,
                        ),
                        onPressed: () async {
                          const url = 'https://www.twitter.com/mtwn105';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new IconButton(
                        icon: new Icon(
                          FontAwesomeIcons.google,
                          size: 36.0,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          const url =
                              'mailto:mtwn105@gmail.com?subject=Decision Maker Feedback';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Theme.of(context).primaryColorDark,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 64.0,
                    onPressed: () async {
                      const url = 'http://bit.ly/amitapps';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    color: Theme.of(context).accentColor,
                    child: Text('More Apps',
                        style:
                            TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
