import 'package:flutter/material.dart';
import 'package:iGerencial/navigation_home.dart';
import 'package:iGerencial/util/util.dart';
import 'package:iGerencial/servico/api.dart';

void main() => runApp(new Login());

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {

  var util = Util();
  final _usuario = TextEditingController();
  final _senha = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;
  //input para o foco
  final FocusNode _usuarioText = FocusNode();
  final FocusNode _senhaText = FocusNode();

  
  @override
  Widget build(BuildContext context) {

    var _body = new Container(
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset("assets/logo/logo.png"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) => _validaLogin(value),
                controller: _usuario,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _usuarioText,
                onFieldSubmitted: (term){
                  fieldFocusChange(context, _usuarioText, _senhaText);
                },
                decoration: InputDecoration(
                  labelText: "Usuário",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  )
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) => _validaSenha(value),
                controller: _senha,
                textInputAction: TextInputAction.done,
                focusNode: _senhaText,
                onFieldSubmitted: (value){
                  _senhaText.unfocus();
                  _onPress(context);
                },
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  )
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ButtonTheme(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () => { _onPress(context)},
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Color(0xFF4474B0),
                  ),
              )
            ],
          ),
        ),
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: _loading ? util.loading() : _body
      ),
    );
  }
  //função para focar no próximo input
  fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);  
  }
  //valida o usuário
  _validaLogin(String texto){
    if (texto.isEmpty) {
      return "Digite o nome de usuário";
    }
    return null;
  }
  //valida a senha
  _validaSenha(String texto){
    if (texto.isEmpty) {
      return "Digite sua senha";
    }
    return null;
  }
  //habilita o carregando até retornar a requisição
  _setaLoading(bool status){
    return setState((){
          _loading = status;
    });
  }
  //ação de logar
  _onPress(BuildContext context) async{
    
    String user = _usuario.text;
    String senha = _senha.text;

    if(!_formKey.currentState.validate())  {
      _setaLoading(false);
      return;
    }else{
      _setaLoading(true);
    }

    var usuario = await Api.login(user, senha);

    if (usuario != null) {
      
      print(" ==> $usuario");
      //NavigationHomeScreen();
      
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
        builder: (context) => NavigationHomeScreen(),
        ),
        ((Route<dynamic> route) => false)
        //ModalRoute.withName('/'),
      );

      //_setaLoading(false);
    }else{
      _setaLoading(false);
      util.alert(context, "Login ou senha Inválido", "Acesso");
    }
  }
}