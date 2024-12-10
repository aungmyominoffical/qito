

import 'package:get/get.dart';

import '../modal/newservermodal.dart';

class ServerController extends GetxController{
  NewServerModal selectedServer = NewServerModal();
  bool premiumServer = false;
  String streamData = "disconnected";
  bool needReward = false;
  bool connected = false;
  Map speed = {};


  setPremium({required bool data}){
    premiumServer = data;
    update();
  }

  setConnected({required bool data}){
    connected = data;
    update();
  }
  setReward({required bool data}){
    needReward = data;
    update();
  }

  setSpeed({required Map data}){
    speed = data;
    update();
  }

  setStream({required String data}){
     streamData = data;
    update();
  }

  setServer({required NewServerModal data}){
    selectedServer = data;
    update();
  }
  clearSelectedServer(){
    selectedServer = NewServerModal();
    update();
  }

}