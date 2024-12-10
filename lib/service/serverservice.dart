import 'dart:convert' as convert;
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_reborn/flutter_html_reborn.dart';
import 'package:get/get.dart';
import 'package:qito/controller/adscontroller.dart';
import 'package:qito/controller/pricecontroller.dart';
import 'package:qito/pages/appupdate.dart';
import 'package:qito/service/servermanagar.dart';
import 'package:qito/supabase/supabaseclient.dart';
import 'notificationservice.dart';


class ServerService {

  PriceController priceController = Get.put(PriceController());
  AdsController adsController = Get.put(AdsController());
  int appVersion = 23;
  String appHistory = "1.2.1";

  checkServerVersion({required BuildContext context})async{
    List result = await SupabaseClientService.configService.select("*");
    Map config = result[0];
    List price = config["price"];
    priceController.setPrice(data: price);
    adsController.setAds(data: config["ads"]);

    if(config["appversion"] > appVersion){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AppUpdatePage(url: config["applink"],)));
    }else{
      if(config["serverversion"] > await ServerManagar().getVersion()){
        print("Update Server");
        NotificationService()
            .showNotification(title: 'Servers Update', body: 'All Servers updated!');
        updateServer(version: config["serverversion"], context: context);
        showModalBottomSheet(
            context: context,
            builder: (context){
              return Container(
                width: context.width,
                height: context.height * 0.4,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: context.width * 0.6,
                          child: const Text("Server Update",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(Icons.clear,color: Colors.red,),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: context.height * 0.3,
                      width: context.width,
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          Html(data: """${config["servermessage"]}""",)
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
        );
      }else{

        NotificationService()
            .showNotification(title: 'Lastest version', body: 'All Servers lastest!');
        showModalBottomSheet(
            context: context,
            builder: (context){
              return Container(
                width: context.width,
                height: 180,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(Icons.clear,color: Colors.red,),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 80,
                      width: context.width,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: const Text("All servers lastest!",style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                    )
                  ],
                ),
              );
            }
        );

      }
    }

  }


  testServerUpdate({required BuildContext context}){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            width: context.width,
            height: context.height * 0.4,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: context.width * 0.6,
                      child: const Text("Server Update",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.clear,color: Colors.red,),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: context.height * 0.3,
                  width: context.width,
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    children: [
                       Html(data: """<p>
Imperdiet dictum mollis fringilla tempor pretium bibendum eros vivamus vulputate potenti curabitur dignissim? Laoreet, sociosqu ad vel. Adipiscing nunc mus malesuada aliquet eget cursus fermentum. Fames penatibus placerat fermentum non ultrices dolor egestas ac aliquam purus. Quam id, fringilla urna inceptos turpis montes nunc nascetur hendrerit. Mi dignissim dolor donec. Posuere porta adipiscing sociis quam varius cubilia cubilia nunc. Odio id potenti dis donec?
</p>""",)
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  updateServer({required int version,required BuildContext context})async{
    List result = await SupabaseClientService.serverService.select("*");
    await ServerManagar().setServer(data: convert.jsonEncode(result).toString(), version: version);
    CherryToast.success(title: const Text("Server Updated.")).show(context);
  }

}