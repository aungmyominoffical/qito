

import 'package:url_launcher/url_launcher.dart';

class IntentService {
  void openFacebook() async {
    /* numeric value ကို https://lookup-id.com/ မှာ ရှာပါ */
    String fbProtocolUrl = "fb://profile/100043119698634";
    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      print("launching..." + fbProtocolUrl);
      if (!launched) {
        print("can't launch");
        await launch(fbProtocolUrl, forceSafariVC: false);
      }
    } catch (e) {
      print("can't launch exp " + e.toString());
      await launch(fbProtocolUrl, forceSafariVC: false);
    }
  }

  void openUrl({required String url})async{
    String fbProtocolUrl = url;
    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      print("launching..." + fbProtocolUrl);
      if (!launched) {
        print("can't launch");
        await launch(fbProtocolUrl, forceSafariVC: false);
      }
    } catch (e) {
      print("can't launch exp " + e.toString());
      await launch(fbProtocolUrl, forceSafariVC: false);
    }
  }
}