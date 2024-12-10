

import 'package:get/get.dart';

class TimeController extends GetxController{
  int time = 0;
  setTime({required int data}){
    time = data;
    update();
  }
}