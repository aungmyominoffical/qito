import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:get/get.dart';
import 'package:qito/controller/servercontroller.dart';
import '../animation/circle_painter.dart';
import '../animation/curve_wave.dart';



class ConnectionButton extends StatefulWidget {
  final V2RayStatus status;
  const ConnectionButton({super.key,required this.status});

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton>with TickerProviderStateMixin {
  late AnimationController _controller;
  ServerController serverController = Get.put(ServerController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                Colors.black,
                Colors.black
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: Icon(Icons.power_settings_new, size: 80,color: Colors.white,)
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return GetBuilder<ServerController>(
        builder: (serverController){
          return Center(
            child: CustomPaint(
              painter: CirclePainter(
                _controller,
                // color: serverController.speed["status"] == "V2RAY_CONNECTED"? Colors.green: serverController.speed["status"] == "V2RAY_DISCONNECTED" || serverController.speed["status"] == null ? Colors.red : Colors.yellow,
                color: widget.status.state == "CONNECTED"? Colors.green: widget.status.state == "DISCONNECTED" || widget.status.state == null ? Colors.red : Colors.yellow,
              ),
              child: SizedBox(
                width: size * 0.5,
                height: size * 0.5,
                child: _button(),
              ),
            ),
          );
        }
    );
  }
}
