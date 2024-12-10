import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qito/controller/pricecontroller.dart';


class PricePage extends StatefulWidget {
  const PricePage({super.key});

  @override
  State<PricePage> createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {

  PriceController priceController = Get.put(PriceController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Price",style: TextStyle(
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
      body: GetBuilder<PriceController>(
        builder: (priceController){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: priceController.priceLists.map((e) {
              return Container(
                width: width * 0.26,
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 5,
                  right: 5
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage(e),
                    width: width * 0.26,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
