import 'package:flutter/material.dart';
import '../service/IntentService.dart';


class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Premium",style: TextStyle(
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
              IntentService().openUrl(url: "https://t.me/qitoadmin");
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const Image(
                image: AssetImage("assets/icons/telegram.png"),
                width: 30,
                height: 30,
              ),
            ),
            title: const Text("Buy Premium - Telegram",style: TextStyle(
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
              IntentService().openUrl(url: "https://m.me/qitotech.mm");
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const Image(
                image: AssetImage("assets/icons/messenger.png"),
                width: 30,
                height: 30,
              ),
            ),
            title: const Text("Buy Premium - Messenger",style: TextStyle(
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
