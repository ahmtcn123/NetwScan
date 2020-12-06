import 'package:flutter/material.dart';

class ScaffoldTitle {
  Row build() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.network_wifi),
        Padding(
          padding: EdgeInsets.only(left: 7.0),
          child: Container(
            height: 30,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "NetwScan",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 30,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "BETA",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 7.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
