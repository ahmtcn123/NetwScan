import 'dart:async';
import 'dart:io';

class PingResponse {
  PingResponse(this.supported, this.reponse);
  final bool supported;
  final bool reponse;
}

Future<bool> resolveStream(Stream<List<int>> stream) async {
  var sum = false;
  await for (var value in stream) {
    var text = value.map((e) => String.fromCharCode(e)).join("");
    sum = text.contains("Received = 1");
  }
  return sum;
}

class Ping { // 192.168.1.100,192.168.1.200
  Ping(this.address);
  final String address;

  Future<PingResponse> send(int resTime) async {
    if (Platform.isWindows) {
      var results = await Process.start("ping", [this.address, "-n", "1", "-w", resTime.toString()], mode: ProcessStartMode.detachedWithStdio);
      var ret = await resolveStream(results.stdout);
      return PingResponse(true,ret);
    } else if (Platform.isLinux) {
      return PingResponse(false, false);
    } else {
      return PingResponse(false, false);
    }
  }
}
