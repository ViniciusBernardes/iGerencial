import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iGerencial/screen/login/login.dart';
import 'package:iGerencial/util/conexao.dart';
import 'package:iGerencial/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'navigation_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool temToken;
  Util utl = Util();

  Conexao con = Conexao();
  var connect;
  var acessa = 0;
  var token2 = "nada";
  
  initState() {
    super.initState();
    connect = "";
 }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Flutter UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: _body(),
      //home: _loading ? utl.loading() : _body
    );
  }

  setToken(vToken){
    setState((){
          acessa = 1;
    });
  }

  _body(){
    
    Future<String> verificaConexao = con.verifica();
    Future<String> token = Util.sharedPersist();

    return 
      FutureBuilder(
        future:verificaConexao,
        builder: (context, snapshot1){
          if(snapshot1.data != "NoConnect"){
            return 
            FutureBuilder(
                future: token,
                builder: (context, snapshot){
                  if (snapshot.hasError) {
                    return Center(child: Text("Erro ao acessar os dados"));
                  } 
                  /*
                  if (!snapshot.hasData) {
                    return Container(
                      child: SizedBox(
                      width: 128,
                      height: 128,
                      child: Image.asset("assets/logo/logo.png"),
                    ),
                    );
                  }
                  */
                  if(snapshot.data == null){
                    //token = snapshot.data;
                    return Login();
                  }else{
                    return NavigationHomeScreen();
                  }
                 
                }
            );
          }else{
            return Center(child: semConexao(context));
          }
        }
    );
  }

  Widget semConexao(BuildContext context) {

    var _body = new Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            width: 128,
            height: 128,
            child: Image.asset("assets/logo.png"),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                "Erro na conxeção com a internet",
                style: TextStyle(color: Color(0xFF4474B0), 
                       fontSize: 16, fontWeight: FontWeight.bold),
              )
            ),
          ),
          SizedBox(
            height: 60,
          ),
          ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                onPressed: () => {
                  setState(() {
                    connect = "1";
                  })
                 },
                child: Text(
                  "Tentar Novamente",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                color: Color(0xFF4474B0),
              ),
          )
        ]
      )
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: _body
      ),
    );
  }

  Widget carregando() {

    var _body = new Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            width: 128,
            height: 128,
            child: Image.asset("assets/logo.png"),
          ),
          
        ]
      )
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: _body
      ),
    );
  }

}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

