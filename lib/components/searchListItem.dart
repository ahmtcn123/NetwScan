import 'package:flutter/material.dart';

class ListItem {
  ListItem(this.title, this.ip);
  final String title;
  final String ip;
  Container build(int item) {
    return Container(
      height: 88,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
                onTap: () {},
                isThreeLine: true,
                leading: Icon(Icons.computer, size: 40.0),
                title: Text(this.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Text(this.ip, textAlign: TextAlign.start),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}


class NoListItem {
  NoListItem(this.title, this.description, this.icon);
  final String title;
  final String description;
  final IconData icon;
  Container build() {
    return Container(
      height: 88,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
                isThreeLine: true,
                leading: Icon(this.icon, size: 40.0),
                title: Text(this.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Text(this.description, textAlign: TextAlign.start),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}