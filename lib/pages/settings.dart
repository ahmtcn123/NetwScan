import 'dart:io';
import 'package:flutter/material.dart';
import 'package:netwscan/utils/ipRange.dart';

import '../components/settingsItem.dart';
import '../utils/Language.dart';
import '../utils/settings.dart';
import '../utils/theme.dart';

class LanguageSelector {
  LanguageSelector(this.id, this.visibleText);
  final String id;
  final visibleText;
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.mainStateSet}) : super(key: key);
  final void Function(void Function() fn) mainStateSet;
  SettingsPageState createState() =>
      SettingsPageState(mainStateSet: this.mainStateSet);
}

class SettingsPageState extends State<SettingsPage> {
  static AppSettings appSettings = AppSettings();
  static AppTheme appTheme = AppTheme();

  SettingsPageState({this.mainStateSet});
  final void Function(void Function() fn) mainStateSet;
  final rangeValue = TextEditingController();
  var rangeCorrect = false;

  @override
  void initState() {
    themeSetting =
        appPrefences.containsKey("theme") ? appPrefences.getInt("theme") : 0;
    searchSpeed = appPrefences.containsKey("searchSpeed")
        ? appPrefences.getInt("searchSpeed").toDouble()
        : 500;
    appTheme.setTheme(themeSetting);
    if (appPrefences.containsKey("ipRange")) {
      rangeCorrect = true;
      rangeValue.text = appPrefences.getString("ipRange");
    }
    rangeValue.addListener(() {
      if (rangeValue.text.contains(",")) {
        var ipRanges = rangeValue.text.split(",");
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
              var ipRange = IpRange(start: firstIp, end: secondIp);
              var totalTick = ipRange.totalTick();
              if (totalTick == 0) {
                setState(() {
                  rangeCorrect = false;
                });
              } else {
                appPrefences.setString("ipRange", rangeValue.text);
                setState(() {
                  rangeCorrect = true;
                });
              }
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
    super.initState();
  }

  /*
    Switch(
      value: this.prefenceRefference.get("theme") || true,
      onChanged: (value) => this.settings[0].data.setValue = value,
    ),

  */

  String version = "v1.0.0-beta";
  String buildNumber = "0x001";
  String lang = appLanguage;

  int themeSetting;
  double searchSpeed = 500.0;
  List<SettingsItem> get settings {
    return [
      SettingsItem(
          defaultLanguage.a10,
          defaultLanguage.a11,
          FlatButton(
            child: Text(this.themeSetting == 0
                ? defaultLanguage.a16 +
                    " (" +
                    (Theme.of(context).brightness == Brightness.light
                        ? defaultLanguage.a8
                        : defaultLanguage.a9) +
                    ")"
                : appTheme.currentThemeID() == 1
                    ? defaultLanguage.a8 + " " + defaultLanguage.a7
                    : this.themeSetting == 2
                        ? defaultLanguage.a9 + " " + defaultLanguage.a7
                        : defaultLanguage.a16 +
                            " (" +
                            (Theme.of(context).brightness == Brightness.light
                                ? defaultLanguage.a8
                                : defaultLanguage.a9) +
                            ")"),
            onPressed: () {
              setState(() {
                this.mainStateSet(() {
                  appTheme.switchTheme();
                  appPrefences.setInt("theme", appTheme.currentThemeID());
                  this.themeSetting = appPrefences.getInt("theme");
                });
              });
            },
            color: this.themeSetting == 0
                ? (Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).accentColor
                    : Colors.grey.shade600)
                : this.themeSetting == 1
                    ? Theme.of(context).accentColor
                    : this.themeSetting == 2
                        ? Colors.grey.shade600
                        : (Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).accentColor
                            : Colors.grey.shade600),
            textColor: Colors.white,
          )),
      SettingsItem(
          defaultLanguage.a12,
          defaultLanguage.a13,
          Slider(
            value: searchSpeed,
            min: 250,
            max: 1000,
            divisions: 5,
            label: searchSpeed.toString(),
            onChanged: (double value) {
              setState(() {
                searchSpeed = value;
                appPrefences.setInt("searchSpeed", value.toInt());
              });
            },
          )),
      SettingsItem(
        defaultLanguage.a14,
        defaultLanguage.a15,
        Container(
          height: 30,
          width: 200,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 3.0,
            ),
            child: TextField(
              maxLength: 27,
              controller: rangeValue,
              autofocus: false,
              style: TextStyle(color: rangeCorrect ? Colors.black : Colors.red),
              decoration: InputDecoration(
                hintText: defaultLanguage.a2,
              ),
            ),
          ),
        ),
      ),
      SettingsItem(
        defaultLanguage.a10,
        defaultLanguage.a11,
        DropdownButton<String>(
          value: appLanguage,
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              appLanguage = newValue;
              defaultLanguage = Language.fromJson(languageJSON[newValue]);
            });
          },
          items: [
            for (var e in languageJSON.entries)
              DropdownMenuItem<String>(
                value: e.key,
                child: Text(
                  e.value["visibleText"],
                ),
              )
          ],
        ),
      ),
      SettingsItem(
        defaultLanguage.a17,
        this.version ?? '',
        Container(width: 40, height: 40, child: Image.asset("Icons/main.png")),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(defaultLanguage.a6),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
              child: ListView.builder(
                  itemCount: settings.length,
                  itemBuilder: (BuildContext ccontext, int index) {
                    return settings[index].build();
                  })),
        ));
  }
}
