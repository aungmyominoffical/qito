

import 'package:get/get.dart';

class UserController extends GetxController{

  bool member = false;


  setMember({required bool data}){
    member = data;
    update();
  }

}