

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:qito/controller/servercontroller.dart';
import 'package:qito/modal/newservermodal.dart';
import 'dart:convert' as convert;

import 'package:qito/service/encryptservice.dart';

class ServerManagar{

  final storage = new FlutterSecureStorage();
  ServerController serverController = Get.put(ServerController());

  Future<int> getVersion()async{
    final result = await storage.read(key: "version");
    if(result == null){
      return 0;
    }else{
      return int.parse(result);
    }
  }

  setServer({required String data,required int version})async{
    await storage.write(key: "servers", value: EncryptData().encryptAES(data));
    await storage.write(key: "version", value: version.toString());
    final result = await storage.read(key: "servers");
    List servers = convert.jsonDecode(EncryptData().decryptAES(result));
    servers.sort((a, b) => a["id"].compareTo(b["id"]));
    NewServerModal serverModal = NewServerModal.fromJson(servers.first);
    serverController.setServer(data: serverModal);
    selectServer(server: serverModal);
  }

  Future<List> getServer()async{
    final result = await storage.read(key: "servers");
    List servers = convert.jsonDecode(EncryptData().decryptAES(result));
    servers.sort((a, b) => a["id"].compareTo(b["id"]));

    return servers;
  }


  selectServer({required NewServerModal server})async{
    Map jsonServer = server.toJson();
    print(convert.jsonEncode(jsonServer));
    await storage.write(key: "selectedServer", value: convert.jsonEncode(jsonServer));
  }

  selectedServerClear()async{
    await storage.delete(key: "selectedServer");
  }

  getSelectedServer()async{
    final result = await storage.read(key: "selectedServer");
    print("selectedServer");
    print(result);
    if(result != null){
      Map<String,dynamic> json = convert.jsonDecode(result);
      serverController.setServer(data: NewServerModal.fromJson(json));
    }
  }

}