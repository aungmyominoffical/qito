import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class AppUpdatePage extends StatefulWidget {
  final String url;
  const AppUpdatePage({super.key,required this.url});

  @override
  State<AppUpdatePage> createState() => _AppUpdatePageState();
}

class _AppUpdatePageState extends State<AppUpdatePage> {


  void openUrl({required String url})async{
    String fbProtocolUrl = url;
    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      print("launching..." + fbProtocolUrl);
      if (!launched) {
        print("can't launch");
        await launch(fbProtocolUrl, forceSafariVC: false);
      }
    } catch (e) {
      print("can't launch exp " + e.toString());
      await launch(fbProtocolUrl, forceSafariVC: false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("App Update",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: (){
          exit(0);
        },
        child: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(20),
              child: ListTile(
                onTap: (){
                  openUrl(url: widget.url);
                },
                leading: ClipRRect(
                  child: Image(
                    image: AssetImage("assets/icons/playstore.png"),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text("Play Store",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),),
                trailing: Icon(Icons.download),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
