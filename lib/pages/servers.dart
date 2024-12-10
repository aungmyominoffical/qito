import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qito/controller/servercontroller.dart';
import 'package:qito/service/servermanagar.dart';
import 'package:qito/widget/servercard.dart';
import '../modal/newservermodal.dart';
import '../service/membership.dart';



class ServersPage extends StatefulWidget {
  const ServersPage({super.key});

  @override
  State<ServersPage> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  ServerController serverController = Get.put(ServerController());
  bool member = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkMember();
  }

  checkMember()async{
    final result = await Membership().checkMemberVaild(context: context);
    setState(() {
      member = result;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Server locations",style: TextStyle(
          color: Colors.white
        ),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: ServerManagar().getServer(),
        builder: (context, snapshot) {
          // return your widget with the data from snapshot

          if(snapshot.hasData == true){
            List servers = snapshot.data!;
            return ListView(
              children: servers.map((e) {
                // ServerModal serverModal = ServerModal.fromJson(e);
                NewServerModal serverModal = NewServerModal.fromJson(e);
                return ServerCard(server: serverModal,member: member,);
              }).toList(),
            );
          }else{
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
