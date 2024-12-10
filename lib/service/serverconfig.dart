

import 'dart:convert';

class ServerConfig{

  config({required String data}){
    String t1 = data.split("ss://")[1];
    String t2 = t1.split("@")[0];
    String serverConfig = t1.split("@")[1];
    String ip = serverConfig.split(":")[0];
    String portConfig = serverConfig.split(":")[1];
    String port = portConfig.split("#")[0];
    String methodConfig = utf8.decode(base64Decode(t2));
    String method = methodConfig.split(":")[0];
    String password = methodConfig.split(":")[1];
    Map config = {
      "ip":ip,
      "port":int.parse(port),
      "method":method,
      "password":password
    };
    return config;
  }

}