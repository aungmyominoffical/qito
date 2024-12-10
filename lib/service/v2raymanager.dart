


import 'package:flutter_v2ray/flutter_v2ray.dart';

class V2rayManager {
  final FlutterV2ray flutterV2ray = FlutterV2ray(
    onStatusChanged: (status) {
      // do something
    },
  );

// You must initialize V2Ray before using it.
  init()async{
    await flutterV2ray.initializeV2Ray();
  }

}