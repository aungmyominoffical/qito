import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qito/modal/profilemodal.dart';
import 'package:qito/service/membership.dart';
import 'package:qito/supabase/supabaseclient.dart';

import '../service/devicemanager.dart';
import '../service/notificationservice.dart';



class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool loading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  loginService()async{
    setState(() {
      loading = true;
    });
    List result = await SupabaseClientService.userService.select("*").eq("username", usernameController.text).eq("password", passwordController.text);
    if(result.length == 0){
      CherryToast.error(title: const Text("No User Found!")).show(context);
    }else{
      Map<String,dynamic> profile = Map<String,dynamic>.from(result[0]);
      Membership().login(profileModal: ProfileModal.fromJson(profile));
      final deviceId = await DeviceManagar().getDeviceId();
      await SupabaseClientService.userService.update({"deviceid":"${deviceId}"}).eq("id", profile["id"]);
      NotificationService()
          .showNotification(title: 'Login Success', body: 'Success!');
      CherryToast.info(title: const Text("Login Success.")).show(context);
      await Membership().checkMembership();
      Navigator.pop(context);
      Navigator.pop(context);
    }
    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Login",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: height * 0.3,
            width: width,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white30
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    top: 15
                  ),
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: usernameController,
                    style: const TextStyle(
                      color: Colors.white70
                    ),
                    decoration: const InputDecoration(
                      hintText: "Username",
                      hintStyle: TextStyle(
                        color: Colors.white70
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 60,
                  child: TextField(
                    controller: passwordController,
                    style: const TextStyle(
                        color: Colors.white70
                    ),
                    decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Colors.white70
                        )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: MaterialButton(
                    onPressed: (){
                      loginService();
                    },
                    height: 45,
                    minWidth: width,
                    color: HexColor("#04422e"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: loading == false ? const Text("Login",style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),): const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
