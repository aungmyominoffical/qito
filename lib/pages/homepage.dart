import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qito/controller/adscontroller.dart';
import 'package:qito/controller/servercontroller.dart';
import 'package:qito/controller/timecontroller.dart';
import 'package:qito/controller/usercontroller.dart';
import 'package:qito/pages/account.dart';
import 'package:qito/pages/contact.dart';
import 'package:qito/pages/joinchannel.dart';
import 'package:qito/pages/price.dart';
import 'package:qito/pages/servers.dart';
import 'package:qito/pages/signin.dart';
import 'package:qito/service/membership.dart';
import 'package:qito/service/serverservice.dart';
import 'package:qito/service/update.dart';
import 'package:qito/widget/connectionbutton.dart';
import 'package:root/root.dart';
import '../admob/admobservice.dart';
import '../blockedpage.dart';
import '../service/servermanagar.dart';
import '../service/timeservice.dart';
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController loginCodeController = TextEditingController();
  AdsController adsController = Get.put(AdsController());
  TimeController timeController = Get.put(TimeController());
  String connectionStatus = "Nothing";
  int initTime = 10800;
  int rewardTime = 10800;

  late DateTime today;


  late BannerAd bannerAd;
  bool bannerLoaded = false;

  RewardedAd? rewardedAd;

  bool rewardLoaded = false;
  bool rewardLoading = false;

  V2RayStatus qitostatus = V2RayStatus();

  late  FlutterV2ray flutterV2ray ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterV2ray = FlutterV2ray(
      onStatusChanged: (status) {
        // do something
        setState(() {
          qitostatus = status;
        });
      },
    );
    FlutterNativeSplash.remove();
    today = DateTime.now();
    // VpnManagar().startListener();
    checkRoot();
  }




  checkExpire()async{
    String result = await Membership().getProfile();
    // ProfileModal data = ProfileModal.fromJson(Map<String,dynamic>.from(convert.jsonDecode(result)));
    // int expire = DateTime.parse("${data.expire}").difference(today).inDays;
    print("ExpiredAt-${result}");

  }

  checkRoot()async{
    await flutterV2ray.initializeV2Ray();
    List blockedApp = ["com.termux"];
    final rooted = await Root.isRooted();
    await TimeService().init();
    TimeService().getTimer();
    ServerManagar().getSelectedServer();
    if(rooted == true ){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  BlockedPage(blockedApp: blockedApp)));
    }
    try{
      await Membership().checkMembership();
    }catch(e){
    }
    try{
      await Membership().checkMemberVaild(context: context);
    }catch(e){}
    checkServerVersion();
    norewardCount();

  }




  checkServerVersion()async{
    AppUpdate.checkForUpdate();
    await ServerService().checkServerVersion(context: context);
    if(adsController.ads == true){
      loadBannerAds();
    }
  }

  loadBannerAds() {
    BannerAd(
      adUnitId: AdmobService.bannerId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            bannerAd = ad as BannerAd;
            bannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          // ad.dispose();
          loadBannerAds();
        },
      ),
    ).load();
  }



  String rewardState = "";


  rewardAds(){
    setState(() {
      rewardState = "loading";
    });
    RewardedAd.load(
        adUnitId: AdmobService.rewardId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              setState(() {
                rewardedAd = ad;
                rewardState = "ready";
              });
            },
            onAdFailedToLoad: (LoadAdError error) {
              setState(() {
                rewardState = "fail";
              });
              print(error.message);
            },

        ));
  }


  late Timer norewardTimer;

  norewardCount() {
    norewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await TimeService().getTimer() == 0 &&
          qitostatus.state == "CONNECTED") {
        if (serverController.needReward == true) {
          disconnect();
        }
      } else {
        if (qitostatus.state == "CONNECTED") {
          TimeService().minusTime();

        }
      }
    });
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft =
    h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
    m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
    s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }

  connectServer() async {

      if (serverController.selectedServer.server != null) {
        if(await TimeService().getTimer() == 0){
          TimeService().addTime(data: initTime);
        }
        if (await flutterV2ray.requestPermission()){
          flutterV2ray.startV2Ray(
            remark: "QITO VPN",
            config: convert.jsonEncode(serverController.selectedServer.server),
            blockedApps: null,
            bypassSubnets: null,
            proxyOnly: false,
          );

        }
        //VpnManagar().connect(key: key);
        await Future.delayed(const Duration(seconds: 5));
        bool hasProfile = await Membership().checkMembership();
        if(hasProfile == true){
          await Membership().auth(context: context);
          await Membership().checkMemberVaild(context: context);
        }else{
          adsController.setAds(data: true);
        }
        loadBannerAds();
        rewardAds();
      } else {
        CherryToast.warning(title: const Text("Select Server!.")).show(context);
      }



  }

  disconnect() {
    serverController.setReward(data: true);
    flutterV2ray.stopV2Ray();

    //VpnManagar().disconnect();
  }

  ServerController serverController = Get.put(ServerController());

  late Timer connectionTimer;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //connectionTimer.cancel();
  }

  UserController userController = Get.put(UserController());

  exitAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            title: const Text("Exit App ?",style: TextStyle(
              fontSize: 22,
              // fontWeight: FontWeight.bold,
              color: Colors.red,
            ),),
            actions: [
              TextButton(
                onPressed: () {
                  //VpnManagar().minimize();
                  Navigator.pop(context);
                },
                child: const Text("Minimize",style: TextStyle(
                  color: Colors.black
                ),),
              ),
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text("Exit",style: TextStyle(
                  color: Colors.red
                ),),
              )
            ],
          );
          // return Dialog(
          //   shape: RoundedRectangleBorder(),
          //   child: Container(
          //     height: 100,
          //     child: Column(
          //       children: [
          //         Text("Exit",style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: Colors.red
          //         ),),
          //         Row(
          //           children: [
          //                 TextButton(
          //                   onPressed: () {
          //                     VpnManagar().minimize();
          //                     Navigator.pop(context);
          //                   },
          //                   child: const Text("Minimize"),
          //                 ),
          //                 TextButton(
          //                   onPressed: () {
          //                     exit(0);
          //                   },
          //                   child: const Text("Exit"),
          //                 )
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // );
        });
  }

  String getNetworkUnit({required int bytes, int decimals = 0}) {
    if(bytes == 0){
      return "0KB";
    }else{
      const suffixes = ["B", "KB", "MB", "GB", "TB"];
      var i = (log(bytes) / log(1024)).floor();
      return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "QITO",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,fontFamily: ""),
        ),
        centerTitle: true,
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          margin: const EdgeInsets.all(10),
          child: InkWell(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(
                Icons.menu_rounded,
                color: Colors.black,
              )),
        ),
        actions: [
          GestureDetector(
            onTap: ()async{
              await ServerService().checkServerVersion(context: context);
            },
            child:  Chip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
              ),
              label: Text("Server"),avatar: Icon(Icons.update),),
          ),
        ],
      ),
      drawer: GetBuilder<UserController>(
        builder: (userController) {
          return Drawer(
            child: Container(
              height: height,
              width: width,
              color: Colors.black,
              child: ListView(
                children: [
                  Container(
                    width: width,
                    height: height * 0.2,
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: const AssetImage("assets/icons/qito.png"),
                        width: width * 0.35,
                        height: width * 0.35,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // GestureDetector(
                  //   onTap: ()async{
                  //     scaffoldKey.currentState!.closeDrawer();
                  //     // login(width: width, height: height);
                  //     await ServerService().checkServerVersion(context: context);
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.only(
                  //       left: 15
                  //     ),
                  //     height: 40,
                  //     child: const Row(
                  //       children: [
                  //         Icon(
                  //           Icons.download_for_offline,
                  //           color: Colors.white54,
                  //           size: 30,
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.only(
                  //             left: 10
                  //           ),
                  //           child: Text(
                  //             "Server Update",
                  //             style: TextStyle(color: Colors.white54,fontSize: 16),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  if (userController.member == false)
                    const Divider(
                      thickness: 1,
                      color: Colors.white30,
                    ),
                  if (userController.member == false)
                    GestureDetector(
                      onTap: (){
                        scaffoldKey.currentState!.closeDrawer();
                        // login(width: width, height: height);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SigninPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 15
                        ),
                        height: 40,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              color: Colors.white54,
                              size: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Premium",
                                    style: TextStyle(color: Colors.white54,fontSize: 16),
                                  ),
                                  Text("Tag to login",style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (userController.member == true)
                    const Divider(
                      thickness: 1,
                      color: Colors.white30,
                    ),
                  if (userController.member == true)
                    GestureDetector(
                      onTap: (){
                        scaffoldKey.currentState!.closeDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyAccountPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 15
                        ),
                        height: 40,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.person_2,
                              color: Colors.white54,
                              size: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10
                              ),
                              child: Text(
                                "My Account",
                                style: TextStyle(color: Colors.white54,fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white30,
                  ),
                  GestureDetector(
                    onTap: (){
                      scaffoldKey.currentState!.closeDrawer();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PricePage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15
                      ),
                      height: 40,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.white54,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10
                            ),
                            child: Text(
                              "Price",
                              style: TextStyle(color: Colors.white54,fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white30,
                  ),
                  GestureDetector(
                    onTap: () {
                      // scaffoldKey.currentState!.closeDrawer();
                      // IntentService().openUrl(url: "https://t.me/qitotech");
                      scaffoldKey.currentState!.closeDrawer();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15
                      ),
                      height: 40,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: Colors.white54,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10
                            ),
                            child: Text(
                              "Buy Premium",
                              style: TextStyle(color: Colors.white54,fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const Divider(
                    thickness: 1,
                    color: Colors.white30,
                  ),

                  GestureDetector(
                    onTap: (){
                      scaffoldKey.currentState!.closeDrawer();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JoinChannelPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15
                      ),
                      height: 40,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.telegram,
                            color: Colors.white54,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10
                            ),
                            child: Text(
                              "Join Channel",
                              style: TextStyle(color: Colors.white54,fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white30,
                  ),

                  if (userController.member == true)
                    GestureDetector(
                      onTap: (){
                        scaffoldKey.currentState!.closeDrawer();
                        // login(width: width, height: height);
                        Membership().logout(context: context, showLogout: true);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 15
                        ),
                        height: 40,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white54,
                              size: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10
                              ),
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.red,fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  if (userController.member == true)
                    const Divider(
                      thickness: 1,
                      color: Colors.white30,
                    ),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15
                      ),
                      height: 40,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info,
                            color: Colors.white54,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Version",
                                  style: TextStyle(color: Colors.white54,fontSize: 16),
                                ),
                                Text(ServerService().appHistory,style: const TextStyle(
                                    color: Colors.white54,
                                  fontSize: 12
                                ),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      body: WillPopScope(
        onWillPop: ()=> exitAlert(),
        child: Column(
          children: [
            GetBuilder<ServerController>(
                builder: (serverController) {
                  return Stack(
                    children: [
                      Container(
                        height: height * 0.32,
                        width: width,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: height * 0.13,
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Upload",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w200),
                                        ),
                                        const Icon(Icons.arrow_upward,color: Colors.red,size: 18,),
                                        Text(
                                          qitostatus.upload == null ? "0B":getNetworkUnit(bytes: qitostatus.upload,decimals: 0),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Download",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w200),
                                      ),
                                      const Icon(Icons.arrow_downward,color: Colors.green,size: 18,),
                                      Text(
                                        qitostatus.download == null ? "0B":getNetworkUnit(bytes: qitostatus.download,decimals: 0),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                qitostatus.state == "CONNECTED" ? "CONNECTED":"DISCONNECTED",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: height * 0.3,
                        width: width,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            if (qitostatus.state == "CONNECTED" || serverController.connected == true) {
                              serverController.setConnected(data: false);
                              disconnect();
                            }else{
                              serverController.setConnected(data: true);
                              connectServer();
                            }

                          },
                          child:  ConnectionButton(status: qitostatus,),
                        ),
                      )
                    ],
                  );
                }),
            GetBuilder<ServerController>(
                builder: (serverController){
                  return Container(
                    width: width * 0.8,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (qitostatus.state !=
                            "CONNECTED") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ServersPage()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GetBuilder<ServerController>(
                          builder: (serverController) {
                            if (serverController.selectedServer.server ==
                                null || serverController.selectedServer.tag == "" || serverController.selectedServer.tag == null) {
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        child: const Icon(
                                          Icons.flag_circle,
                                          size: 50,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Text(
                                          "Select Server",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: const Image(
                                      image:
                                      AssetImage("assets/icons/free.png"),
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/flags/${serverController.selectedServer.country!.flag}.png"),
                                      width: 40,
                                      height: 25,
                                      fit: BoxFit.fill,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      width: width * 0.5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${serverController.selectedServer.country!.server}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            "${serverController.selectedServer.tag}",
                                            style: TextStyle(
                                                color: Colors.grey.shade50,
                                                fontSize: 12
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image(
                                    image:
                                    serverController.selectedServer.type ==
                                        "free"
                                        ? const AssetImage(
                                        "assets/icons/free.png")
                                        : const AssetImage(
                                        "assets/icons/premium.png"),
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
            ),
            GetBuilder<UserController>(builder: (userController) {
              if (userController.member == false) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      GetBuilder<TimeController>(
                          builder: (timeController){
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 10,
                                  right: 10
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 1
                                  )
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.access_time,color: Colors.white,size: 30,),
                                title: const Text("Left Time",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),),
                                subtitle: Text(
                                  intToTimeLeft(timeController.time),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),

                                trailing: rewardState == "loading"?
                                MaterialButton(
                                  onPressed: (){},
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  color: Colors.yellow,
                                  child: const Text("Ads is Loading",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),),
                                ):
                                rewardState == "fail"?
                                MaterialButton(
                                  onPressed: (){
                                    //rewardLoad();
                                    rewardAds();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  color: Colors.red,
                                  child: const Text("Ad Fail - Retry",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),),
                                ):
                                MaterialButton(
                                  onPressed: (){
                                    rewardedAd?.show(
                                        onUserEarnedReward: (view,item){
                                          setState(() {
                                            rewardState = "loading";
                                          });
                                            TimeService().addTime(data: rewardTime);
                                            serverController.setReward(data: false);
                                            rewardAds();
                                        }
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  color: Colors.green,
                                  child: const Text("Add Time",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),),
                                ),
                              ),
                            );
                          }
                      ),
                      // MaterialButton(
                      //   onPressed: () async{
                      //     if (serverController.speed["status"] ==
                      //         "V2RAY_CONNECTED") {
                      //       print("R1");
                      //       if(adsController.ads == true){
                      //         print("R2");
                      //          rewardLoadingDialog();
                      //       }
                      //     }
                      //
                      //
                      //   },
                      //   minWidth: width * 0.8,
                      //   height: 40,
                      //   color: Colors.indigo,
                      //   child: Text(
                      //     "Add Time",
                      //     style: TextStyle(color: Colors.white, fontSize: 16),
                      //   ),
                      // )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
            if (bannerLoaded == true)
              GetBuilder<AdsController>(
                  builder: (adsController){
                    if(adsController.ads == true){
                      // return MaxAdView(
                      //     adUnitId: AppLovinConstant.mrec,
                      //     adFormat: AdFormat.mrec,
                      //     listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                      //       print('Banner widget ad loaded from ${ad.networkName}');
                      //     }, onAdLoadFailedCallback: (adUnitId, error) {
                      //       print('Banner widget ad failed to load with error code ${error.code} and message: ${error.message}');
                      //     }, onAdClickedCallback: (ad) {
                      //       print('Banner widget ad clicked');
                      //     }, onAdExpandedCallback: (ad) {
                      //       print('Banner widget ad expanded');
                      //     }, onAdCollapsedCallback: (ad) {
                      //       print('Banner widget ad collapsed');
                      //     }, onAdRevenuePaidCallback: (ad) {
                      //       print('Banner widget ad revenue paid: ${ad.revenue}');
                      //     }));
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 30),
                          width: bannerAd.size.width.toDouble(),
                          height: bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: bannerAd),
                        ),
                      );
                    }else{
                      return Container();
                    }
                  }
              ),

          ],
        ),
      ),
    );
  }
}
