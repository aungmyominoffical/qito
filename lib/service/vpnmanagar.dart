


import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qito/controller/servercontroller.dart';
import 'notificationservice.dart';

class VpnManagar {
  MethodChannel channel = const MethodChannel("shortwave.v2ray/qito");


  test()async{
    await channel.invokeMethod("test");
  }

  Future vpnStatus()async {
   final result =  await channel.invokeMethod("vpnstatus");
   return result;

  }

  Future getConnectionstatus()async{
    final result = await channel.invokeMethod("connectionstatus");
    return result;
  }
  
  vibrate()async{
    await channel.invokeMethod("vibrate");
  }

  connect ({required String key}) async {
    serverController.setStream(data: "connecting");
    await Future.delayed(const Duration(seconds: 1));
    vibrate();
    channel.invokeMethod("connect",{"key":key});
    serverController.setStream(data: "connected");
    NotificationService()
        .showNotification(title: 'VPN Connected', body: 'Connected');
  }

  disconnect()async{
    serverController.setStream(data: "disconnecting");
    vibrate();
    channel.invokeMethod("disconnect");
    await Future.delayed(const Duration(seconds: 1));
    serverController.setStream(data: "disconnected");
    NotificationService()
        .showNotification(title: 'VPN Disconnected', body: 'Disconnected');
  }

  minimize()async{
    await channel.invokeMethod("minimize");
  }

  exit()async{
    await channel.invokeMethod("exit");
  }

  report()async{
    await channel.invokeMethod("report");
  }


  static const stream = EventChannel('shortwave.v2ray/event');
  ServerController serverController = Get.put(ServerController());

  late StreamSubscription _streamSubscription;

  startListener() {
    _streamSubscription = stream.receiveBroadcastStream().listen(listenStream);
  }

  cancelListener() {
    _streamSubscription.cancel();
    serverController.setSpeed(data: {});
  }

  listenStream(value) {
    // if(serverController.streamData != "connected"){
    //   serverController.setStream(data: value);
    // }
    // if(serverController.streamData != "disconnected"){
    //   serverController.setStream(data: value);
    // }
    // if(serverController.streamData != "disconnecting"){
    //   serverController.setStream(data: value);
    // }
    // serverController.setStream(data: value);
    List speed = value.toString().split("&");
    String download = speed[0];
    String upload = speed[1].toString().split("#")[0];
    String status = value.toString().split("#")[1];
    Map speedMap = {
      "download":download ,
      "upload":upload ,
      "status":status ,
    };

    report();
    serverController.setSpeed(data: speedMap);
  }

}