import 'package:flutter/material.dart';

import '../service/IntentService.dart';



class JoinChannelPage extends StatefulWidget {
  const JoinChannelPage({super.key});

  @override
  State<JoinChannelPage> createState() => _JoinChannelPageState();
}

class _JoinChannelPageState extends State<JoinChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Join Channel",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: (){
              IntentService().openUrl(url: "https://t.me/qitotech");
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const Image(
                image: AssetImage("assets/icons/telegram.png"),
                width: 30,
                height: 30,
              ),
            ),
            title: const Text("Telegram Channel",style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),

          ),
          const Divider(
            thickness: 2,
            color: Colors.white30,
          ),
          ListTile(
            onTap: (){
              IntentService().openUrl(url: "fb://page/106584461951456");
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const Image(
                image: AssetImage("assets/icons/facebook.png"),
                width: 30,
                height: 30,
              ),
            ),
            title: const Text("Facebook Page",style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),

          ),
          const Divider(
            thickness: 2,
            color: Colors.white30,
          ),
        ],
      ),

    );
  }
}
