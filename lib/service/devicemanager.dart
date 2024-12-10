

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceManagar {
  final storage = new FlutterSecureStorage();
  var uuid = Uuid();


  Future<String> createDeviceId()async{
    final id = uuid.v4();
    await storage.write(key: "device", value: id);
    return id;
  }

  Future<String> getDeviceId()async{
    final deviceId =await  storage.read(key: "device");
    print(deviceId);
    if(deviceId == null){
      final result = await createDeviceId();
      print(result);
      return result;
    }
    return deviceId;
  }



}