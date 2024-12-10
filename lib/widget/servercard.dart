import 'package:cherry_toast/cherry_toast.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qito/controller/servercontroller.dart';
import 'package:qito/modal/newservermodal.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

import '../service/servermanagar.dart';



class ServerCard extends StatefulWidget {
  final NewServerModal server;
  final bool member;
  const ServerCard({super.key,required this.server,required this.member});

  @override
  State<ServerCard> createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  late PingData result;
  double signalStrength = 0.0;
  bool loading = true;
  ServerController serverController = Get.put(ServerController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPing();
  }

  getPing()async{
    PingData data = await Ping('${widget.server.dns}', count: 1).stream.first;
    setState(() {
      int? time = data.response?.time?.inMicroseconds == null ? 200 : data.response?.time?.inMicroseconds;
      print(time);
      signalStrength = (time! / 600);
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.8,
      height: 70,
      margin:const EdgeInsets.only(
          top: 2,
          left: 10,
          right: 10,
          bottom: 2
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white30
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: ()async{

          if(widget.server.type == "premium"){
            serverController.setPremium(data: true);
            print("Premium Server");
            if(widget.member == true){
              print("Premium User");
              serverController.setServer(data: widget.server);
              ServerManagar().selectServer(server: widget.server);
              Navigator.pop(context);
            }else{

              print("No Premium User");
              CherryToast.warning(
                  title: const Text("Only Premium User!."))
                  .show(context);
            }
          }else{
            serverController.setPremium(data: false);
            print("Free Server");
            serverController.setServer(data: widget.server);
            ServerManagar().selectServer(server: widget.server);
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image(
                    image: AssetImage("assets/flags/${widget.server.country!.flag}.png"),
                    width: 40,
                    height: 25,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    width: width * 0.5,
                    margin: EdgeInsets.only(
                        left: 10
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${widget.server.country!.server}",style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          fontFamily: "Oswald"
                        ),maxLines: 1,),
                        Text("${widget.server.tag}",style: TextStyle(
                            color: Colors.grey.shade50,
                            fontSize: 12
                        ),maxLines: 1,),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: loading == true ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                ): SignalStrengthIndicator.bars(
                  value: signalStrength,
                  size: 20,
                  barCount: 4,
                  spacing: 0.2,
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                ),
              ),

              widget.server.type == "free" ? Image(
                image: AssetImage("assets/icons/free.png"),
                width: 30,
                height: 30,
                fit: BoxFit.fitWidth,
              ) : Image(
                image: AssetImage("assets/icons/vip.png"),
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
