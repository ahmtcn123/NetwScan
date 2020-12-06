import 'dart:io';
import 'package:flutter/foundation.dart';

class IpRange {
  IpRange({@required this.start, @required this.end});
  final InternetAddress start;
  final InternetAddress end;

  int totalTick() {
    var first = ((255 * 256) * 256) *
        (this.end.rawAddress[0] - this.start.rawAddress[0]);
    var second =
        (255 * 265) * (this.end.rawAddress[1] - this.start.rawAddress[1]);
    var third = 255 * (this.end.rawAddress[2] - this.start.rawAddress[2]);
    var fourth = (this.end.rawAddress[3] - this.start.rawAddress[3]);
    return fourth + third + second + first;
  }

  void processIp(Future<bool> Function(InternetAddress ip, int move) tickProvider) async {
    var keepProcess = true;
    var move = 0;
    var start = this.start.rawAddress;
    var end = this.end.rawAddress;
    do {
      if (start[3] == 255) {
        start[3] = 0;
        if (start[2] == 255) {
          start[2] = 0;
          if (start[1] == 255) {
            start[1] = 0;
            if (start[0] == 255) {
              start[0] = 0;
            } else {
              start[0]++;
            }
          } else {
            start[1]++;
          }
        } else {
          start[2]++;
        }
      } else {
        move++;
        start[3]++;
        if(start[0] == end[0] && start[1] == end[1] && start[2] == end[2] && start[3] == end[3]) {
          keepProcess = false;
          tickProvider(InternetAddress.fromRawAddress(start), move);
        } else {
          keepProcess = await tickProvider(InternetAddress.fromRawAddress(start), move);
        }
      }
    } while ((start[0] < end[0] ||
        start[1] < end[1] ||
        start[2] < end[2] ||
        start[3] < end[3]) && keepProcess);
  }
}
