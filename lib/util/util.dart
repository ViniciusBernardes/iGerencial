
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  
  alert(BuildContext context, String msg, String titulo){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"), 
              onPressed: () {
                Navigator.pop(context);
              }
            )
          ],
        );
      }
    );
  }
  
  static Future<String> sharedPersist() async {
    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? null);
    return token;
  }
  
  loading(){
    return (
      Container(
        child: new Stack(
          children: <Widget>[
            new Container(
              alignment: AlignmentDirectional.center,
              decoration: new BoxDecoration(
                color: Colors.white70,
              ),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(10.0)
                ),
                width: 250.0,
                height: 180.0,
                alignment: AlignmentDirectional.center,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Center(
                      child: new SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: new CircularProgressIndicator(
                          value: null,
                          strokeWidth: 7.0,
                          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF4474B0)),
                          //backgroundColor: Color(0xFF4474B0),
                        ),
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: new Center(
                        child: new Text(
                          "Carregando...",
                          style: new TextStyle(
                            color: Color(0xFF4474B0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }


}