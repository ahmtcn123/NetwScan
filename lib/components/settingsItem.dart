import 'package:flutter/material.dart';

class SettingsItem {
  SettingsItem(this.title, this.description, this.action);

  final String title;
  final String description;
  final Widget action;

  Container build() {
    return Container(
      height: 88,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              isThreeLine: true,
              title: Text(this.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(this.description, textAlign: TextAlign.start),
                      this.action
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}