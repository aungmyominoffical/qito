


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:qito/controller/timecontroller.dart';

class TimeService {
  final storage = new FlutterSecureStorage();
  TimeController timeController = Get.put(TimeController());

  init()async{
    final result = await storage.read(key: "time");
    if(result == null){
      await storage.write(key: "time", value: 0.toString());
      timeController.setTime(data: 0);
    }
  }

  minusTime ()async{
    int time = await getTimer();
    int newTime = time - 1;
    await storage.write(key: "time", value: newTime.toString());
    timeController.setTime(data: newTime);
  }

  getTimer ()async{
    final result = await storage.read(key: "time");
    if(result == null){
      int time = 300;
      timeController.setTime(data: time);
      return time;
    }else{
      int time = int.parse(result.toString());
      timeController.setTime(data: time);
      return time;
    }
  }

  addTime({required int data})async{
    int time = await getTimer();
    int newTime = time + data;
    await storage.write(key: "time", value: newTime.toString());
    timeController.setTime(data: newTime);
  }

}