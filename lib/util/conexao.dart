import 'package:connectivity/connectivity.dart';

class Conexao{

  Future<String> verifica() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
      return "mobile";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      return "wifi";
    } else {
      print("Unable to connect. Please Check Internet Connection");
      return "NoConnect";
    }
  }
    
      
}