import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/ipRange.dart';
import '../utils/ping.dart';
import '../utils/Language.dart';
import '../utils/settings.dart';
import '../utils/theme.dart';

import '../pages/settings.dart';

//Components
import '../components/searchListItem.dart';
import '../components/title.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.mainStateSet}) : super(key: key);

  final void Function(void Function() fn) mainStateSet;
  HomePageState createState() => HomePageState(mainStateSet: this.mainStateSet);
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  HomePageState({this.mainStateSet});
  final void Function(void Function() fn) mainStateSet;

  final searchValue = TextEditingController();
  var rangeCorrect = false;
  var initialized = false;
  var first = true;
  var onProgress = false;
  var progressValue = 0.0;
  var found = [];
  var tryCancel = false;

  static AppSettings appSettings = AppSettings();
  static AppTheme appTheme = AppTheme();

  @override
  void initState() {
    super.initState();
    searchValue.addListener(() {
      if (searchValue.text.contains(",")) {
        var ipRanges = searchValue.text.split(",");
        if (ipRanges.length != 2) {
          setState(() {
            rangeCorrect = false;
          });
        } else {
          try {
            var firstIp = InternetAddress(ipRanges[0]);
            var secondIp = InternetAddress(ipRanges[1]);
            if (firstIp.type == InternetAddressType.IPv4 &&
                secondIp.type == InternetAddressType.IPv4) {
              setState(() {
                rangeCorrect = true;
              });
            } else {
              setState(() {
                rangeCorrect = false;
              });
            }
          } catch (_) {
            setState(() {
              rangeCorrect = false;
            });
          }
        }
      } else {
        setState(() {
          rangeCorrect = false;
        });
      }
      //
    });
  }

  Future<bool> loadLanguageAsset() {
    return Future.sync(() async {
      if (!initialized) {
        await appSettings.init();
        appLanguage = appPrefences.containsKey("language")
            ? appPrefences.getString("language")
            : Platform.localeName.replaceAll("_", "-");
        var theme = appPrefences.containsKey("theme")
            ? appPrefences.getInt("theme")
            : 0;
        appTheme.setTheme(theme);
        var json = await rootBundle.loadString('lib/language.json');
        languageJSON = jsonDecode(json);
        defaultLanguage = Language.fromJson(languageJSON[appLanguage]);
        if (appPrefences.containsKey("ipRange")) {
          this.rangeCorrect = true;
          searchValue.text = appPrefences.getString("ipRange");
        }
        this.mainStateSet(() {});
        initialized = true;
      }

      return true;
    });
  }

  void onIpRangeSelected(String ip) async {
    first = false;
    if (rangeCorrect) {
      var ipRanges = searchValue.text.split(",");
      var firstIp = InternetAddress(ipRanges[0]);
      var secondIp = InternetAddress(ipRanges[1]);
      var ipRange = IpRange(start: firstIp, end: secondIp);
      var totalTick = ipRange.totalTick();

      if (totalTick > 0) {
        setState(() {
          found = [];
          onProgress = true;
        });
        var firstPing = await Ping(firstIp.address).send(appPrefences.containsKey("searchSpeed") ? appPrefences.getInt("searchSpeed") : 500);
        if (firstPing.supported) {
          ipRange.processIp((ip, move) async {
            double percent = (move * 1.0 / totalTick);
            var ping = await Ping(ip.address).send(appPrefences.containsKey("searchSpeed") ? appPrefences.getInt("searchSpeed") : 500);
            setState(() {
              if (percent == 1.0) {
                onProgress = false;
                progressValue = 0.0;
              } else {
                progressValue = percent;
              }
            });
            if (ping.reponse) {
              try {
                var reversed = await ip.reverse();
                setState(() {
                  found.add([reversed.host, ip.address]);
                });
              } catch (_) {
                setState(() {
                  found.add([ip.address, ip.address]);
                });
              }
            } else {}
            if (tryCancel) {
              onProgress = false;
              progressValue = 0.0;
            }
            return !tryCancel;
          });
        } else {
          onProgress = false;
          progressValue = 0.0;
          showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: Text(defaultLanguage.a26),
              content: Text(defaultLanguage.a27),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {
                      found = [];
                      onProgress = false;
                      progressValue = 0.0;
                    });
                  },
                  child: new Text(defaultLanguage.a28),
                ),
              ],
            ),
          );
        }
        if (firstPing.reponse) {
          try {
            var reversed = await firstIp.reverse();
            setState(() {
              found.add([reversed.host, firstIp.address]);
            });
          } catch (_) {
            setState(() {
              found.add([firstIp.address, firstIp.address]);
            });
          }
        }
        tryCancel = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(defaultLanguage.a19),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(defaultLanguage.a20),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(
                          mainStateSet: this.mainStateSet,
                        )),
              ),
              icon: Icon(Icons.settings),
            )
          ],
          title: ScaffoldTitle().build()),
      body: FutureBuilder<bool>(
        future: loadLanguageAsset(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: onProgress ? 1.0 : 0.0,
                    child: LinearProgressIndicator(
                      value: progressValue,
                      //backgroundColor: Colors.red,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).secondaryHeaderColor),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, bottom: 12.0, top: 5.0),
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 20,
                      child: Builder(
                        builder: (context2) => Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(
                                  360,
                                ),
                                color: Colors.white,
                                child: InkWell(
                                  splashColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  borderRadius: BorderRadius.circular(
                                    360,
                                  ),
                                  onTap: () => onProgress
                                      ? () {
                                          tryCancel = true;
                                        }()
                                      : onIpRangeSelected(searchValue.text),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      3.0,
                                    ),
                                    child: Icon(
                                      onProgress ? Icons.clear : Icons.search,
                                      size: 25,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 30,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 3.0,
                                  ),
                                  child: TextField(
                                    maxLength: 27,
                                    enabled: !onProgress, //searchState,
                                    controller: searchValue,
                                    cursorColor: Colors.white,
                                    autofocus: false,
                                    style: TextStyle(
                                      color: rangeCorrect
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (e) =>
                                        onIpRangeSelected(searchValue.text),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                      hintText: defaultLanguage.a2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 107,
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              defaultLanguage.a1,
                              textAlign: TextAlign.start,
                              style:
                                  Theme.of(context).primaryTextTheme.headline5,
                            ),
                          ),
                          AnimatedCrossFade(
                              duration: Duration(milliseconds: 350),                              crossFadeState: found.length == 0
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: ListView.builder(
                                    itemCount: found.length,
                                    itemBuilder:
                                        (BuildContext ccontext, int index) {
                                      return ListItem(
                                              found[index][0], found[index][1])
                                          .build(index);
                                    }),
                              ),
                              secondChild: NoListItem(
                                      onProgress ? defaultLanguage.a29 : first ? defaultLanguage.a24 : defaultLanguage.a5,
                                      onProgress ? defaultLanguage.a30 : first ? defaultLanguage.a25 : defaultLanguage.a23,
                                      onProgress ? Icons.search : first ? Icons.network_wifi : Icons.wifi_off
                                    )
                                  .build())
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Text("Something wrong");
          }
        },
      ),
    );
  }
}
