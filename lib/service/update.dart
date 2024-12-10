import 'package:in_app_update/in_app_update.dart';

class AppUpdate {
  static checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {

      if(info.updateAvailability == UpdateAvailability.updateAvailable && info.flexibleUpdateAllowed == true){


        InAppUpdate.startFlexibleUpdate().then((_) {

        }).catchError((e) {

        });

      }

    }).catchError((e) {

    });
  }
}