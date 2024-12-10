

import 'package:get/get.dart';

class AdsController extends GetxController{

  bool ads = false;

  setAds({required bool data}){
    ads = data;
    update();
  }

}