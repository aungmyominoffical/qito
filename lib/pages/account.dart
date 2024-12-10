import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qito/modal/profilemodal.dart';
import 'package:qito/service/membership.dart';
import 'dart:convert' as convert;



class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late ProfileModal profileModal;
  bool loading = true;
  String password = "";
  bool visiblePw = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  getProfile()async{
    String result = await Membership().getProfile();
    ProfileModal data = ProfileModal.fromJson(Map<String,dynamic>.from(convert.jsonDecode(result)));
    setState(() {
      profileModal = data;
      password = profileModal.password.toString();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Account",style: TextStyle(
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
      body: loading == true ? const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CupertinoActivityIndicator(
            color: Colors.white,
          ),
        ),
      ):Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          height: 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: const Icon(Icons.person_2,),
                title: Text(profileModal.username!),
              ),
              ListTile(
                leading: const Icon(Icons.lock,),
                title: Text(password),
                trailing: IconButton(
                  onPressed: (){
                    if(visiblePw == true){
                      setState(() {
                        password = "";
                      });
                      for (int i = 0; i < profileModal.password!.length; i++) {
                        setState(() {
                          password = password + "*";
                        });
                      }
                      setState(() {
                        visiblePw = false;
                      });
                    }else{
                     setState(() {
                       password = profileModal.password.toString();
                       visiblePw = true;
                     });
                    }
                  },
                  icon: visiblePw == false ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.date_range,),
                title: Text(profileModal.expire!),
              )
            ],
          ),
        ),
      ),
    );
  }
}
