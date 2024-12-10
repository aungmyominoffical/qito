

import 'package:get/get.dart';

class PriceController extends GetxController{
  List priceLists = [];

  setPrice({required List data}){
    priceLists = data;
    update();
  }

}