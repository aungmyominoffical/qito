


import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:qito/controller/servercontroller.dart';
import 'package:qito/controller/usercontroller.dart';
import 'package:qito/modal/newservermodal.dart';
import 'package:qito/modal/profilemodal.dart';
import 'package:qito/service/devicemanager.dart';
import 'package:qito/service/servermanagar.dart';
import 'package:qito/service/vpnmanagar.dart';
import 'dart:convert' as convert;
import 'package:qito/supabase/supabaseclient.dart';

class Membership {

  final storage = new FlutterSecureStorage();
  ServerController serverController = Get.put(ServerController());
  UserController userController = Get.put(UserController());

  login({required ProfileModal profileModal})async{
   Map<String,dynamic> profile = profileModal.toJson();
   await storage.write(key: "profile", value: convert.jsonEncode(profile).toString());
  }

  logout({required BuildContext context,required bool showLogout})async{
    await storage.delete(key: "profile");
    if(showLogout == true){
      CherryToast.success(title: Text("Logout!")).show(context);
    }
    serverController.setServer(data: NewServerModal.fromJson({}));
    ServerManagar().selectServer(server: NewServerModal.fromJson({}));
    userController.setMember(data: false);

  }

  Future<bool> checkMembership()async{
    final result = await storage.read(key: "profile");
    if(result == null){
      userController.setMember(data: false);
      return false;
    }else{
      userController.setMember(data: true);
      return true;
    }
  }

  Future getProfile()async{
    final result = await storage.read(key: "profile");
    return result;
  }

  checkDeviceLimit({required BuildContext context})async{
    final result = await getProfile();
    if(result != null){
      final profile = convert.jsonDecode(result);
      List data = await SupabaseClientService.userService.select("*").eq("username", profile["username"]);
      print("checkdevicelimit");
      print(data.length);
      if(data.length != 0){
        Map<String,dynamic> serverUserProfile = data[0];
        await login(profileModal: ProfileModal.fromJson(serverUserProfile));
        // if(serverUserProfile["type"] == "device"){
          print("deviceid");
          final deviceId = await DeviceManagar().getDeviceId();
          print(deviceId);
          if(serverUserProfile["deviceid"] == deviceId){
            print("Same Device Id");

          }else{
            print("Duplicated Devices");
            logout(context: context,showLogout: false);
            CherryToast.warning(title: Text("Duplicated Devices")).show(context);
          }




      }else{
        logout(context: context,showLogout: true);
      }
    }else{
      print("No User");
    }
  }


  auth({required BuildContext context})async{
    final result = await getProfile();
    final profile = convert.jsonDecode(result);
    List data = await SupabaseClientService.userService.select("*").eq("username", profile["username"]);
    if(data.isNotEmpty){
      String deviceId = await DeviceManagar().getDeviceId();
      Map<String,dynamic> profile = data[0];
      DateTime profileValid = DateTime.parse(profile["expire"]);
      int leftDays = await daysBetween(profileValid, DateTime.now());
      if(leftDays < 0){
        print("Expired");
        await VpnManagar().disconnect();
        await ServerManagar().selectedServerClear();
        serverController.clearSelectedServer();
        serverController.setReward(data: true);
        logout(context: context,showLogout: true);
        CherryToast.info(title: Text("Account Expired")).show(context);
      }else{
        serverController.setReward(data: false);
      }
      if(profile["deviceid"] == deviceId){
        serverController.setReward(data: false);
        print("Same");
      }else{
        print("No Same");
        await VpnManagar().disconnect();
        await ServerManagar().selectedServerClear();
        serverController.clearSelectedServer();
        serverController.setReward(data: true);
        logout(context: context,showLogout: false);
        CherryToast.info(title: Text("Duplicated Account")).show(context);
      }
      print("Auth");

    }else{
      VpnManagar().disconnect();
      ServerManagar().selectedServerClear();
      logout(context: context,showLogout: true);
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (from.difference(to).inHours / 24).round();
  }

  checkMemberVaild({required BuildContext context})async{
    final result = await storage.read(key: "profile");
    Map<String,dynamic> profile = Map<String,dynamic>.from(convert.jsonDecode(result!));
    DateTime expireDate = DateTime.parse(profile["expire"]);
    int leftDays = daysBetween(expireDate,DateTime.now());
    if(leftDays <= 0){
      logout(context: context, showLogout: true);
      CherryToast.warning(title: Text("Account Expired!")).show(context);
      return false;
    }else{
      return true;
    }
  }


}