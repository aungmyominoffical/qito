import 'dart:io';

import 'package:flutter/material.dart';



class BlockedPage extends StatefulWidget {
  final List blockedApp;
  const BlockedPage({super.key,required this.blockedApp});

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Rooted Device",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: (){
          exit(0);
        },
        child: Center(
          child: Container(
            width: width,
            height: 150,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Device is Rooted or Blocked Apps",style: TextStyle(
                color: Colors.red,
              fontWeight: FontWeight.bold,
            ),),
                Text("Rootes Device is not allow and blocks app are follows",style: TextStyle(
                  color: Colors.black
                ),),
                Text(widget.blockedApp.toString(),style: TextStyle(
                    color: Colors.black
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
