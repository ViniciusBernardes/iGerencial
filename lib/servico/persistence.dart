import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Persistence{
  
  static Future<String> verificaToken() async {
    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? null);
    return token;
  }

  static removeLogin() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("token");
  }

  setLogin(usuario, token) async {
    var prefs = await SharedPreferences.getInstance();
    
    prefs.setString("token", token);
    prefs.setString("user", usuario);
  }

  getToken() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }

  static Future<String> getUser() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("user");
    return token;
  }


}