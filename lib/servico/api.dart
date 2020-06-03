import 'package:http/http.dart' as http;
import 'package:iGerencial/screen/chamados/chamados.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iGerencial/servico/persistence.dart';
import 'package:iGerencial/screen/login/usuario.dart';
import 'package:iGerencial/screen/boletos/boletos.dart';

class Api{

  static Future<Usuario> login(String user, String senha) async {
   
    var url = 'http://construtoraeletricaluz.com.br/gerencial/Flutter/logar';
    
    var header = {"context-type":"application/json"};
    Map params = {
      "usuario" : user,
      "senha": senha
    };
    
    var usuario;

    var persist = Persistence();

    var _body = json.encode(params);
    
    var response = await http.post(url, headers: header, body: _body);

    Map mapResponde = json.decode(response.body);
    
    if(response.statusCode == 200){
      usuario = Usuario.fromJson(mapResponde);
      persist.setLogin(mapResponde["nome"], mapResponde["token"]);
    }else{
      usuario = null;
    }
    
   return usuario; 
  }

  static Future<List<Chamados>> listaChamados() async {

    var url = 'http://construtoraeletricaluz.com.br/gerencial/Flutter/mostraChamadosMG';
    
    //var persist = Persistence();
    var chamados;
    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? "");
    
    print("token persiste: $token");
    
    var header = {"context-type":"application/json"};
    Map params = {
      "token" : token
    };
  
    var _body = json.encode(params);
    
    var response = await http.post(url, headers: header, body: _body);
    if(response.statusCode == 200){
      List listResponde = json.decode(response.body);

      chamados = List<Chamados>();
      for(Map map in listResponde){
        Chamados c = Chamados.fromJson(map);
        chamados.add(c);
      }
      return chamados;
    }else{
      throw Exception;
    }
  }

  static Future<List<Chamados>> listaChamadosES() async {

    var url = 'http://construtoraeletricaluz.com.br/gerencial/Flutter/mostraChamadosES';
    
    //var persist = Persistence();
    var chamados;
    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? "");
    
    print("token persiste: $token");
    
    var header = {"context-type":"application/json"};
    Map params = {
      "token" : token
    };
  
    var _body = json.encode(params);
    
    var response = await http.post(url, headers: header, body: _body);
    if(response.statusCode == 200){
      List listResponde = json.decode(response.body);

      chamados = List<Chamados>();
      for(Map map in listResponde){
        Chamados c = Chamados.fromJson(map);
        chamados.add(c);
      }
      return chamados;
    }else{
      throw Exception;
    }
  }

  static Future<bool> baixaChamado(chamado) async {

    var url = 'http://construtoraeletricaluz.com.br/gerencial/Flutter/baixaChamado';
    
    var header = {"context-type":"application/json"};
    Map params = {
      "chamado" : chamado
    };
    
    var _body = json.encode(params);
    
    var response = await http.post(url, headers: header, body: _body);
    if(response.statusCode == 200){
      var retorno = json.decode(response.body);
      return retorno;
    }else{
      throw Exception;
    }
  }

  static Future<bool> baixaBoleto(boleto) async {

    var url = 'http://construtoraeletricaluz.com.br/gerencial/Flutter/baixaBoleto';
    
    var header = {"context-type":"application/json"};
    Map params = {
      "boleto" : boleto
    };
    
    var _body = json.encode(params);
    
    var response = await http.post(url, headers: header, body: _body);
    if(response.statusCode == 200){
      var retorno = json.decode(response.body);
      return retorno;
    }else{
      throw Exception;
    }
  }

  static Future<List<Boletos>> listaBoletos() async {

    var url = 'http://construtoraeletricaluz.com.br/gerencial/Flutter/boletosAvencer';
    
    //var persist = Persistence();
    var boletos;
    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? "");
    
    print("token persiste: $token");
    
    var header = {"context-type":"application/json"};
    Map params = {
      "token" : token
    };
  
    var _body = json.encode(params);
    
    var response = await http.post(url, headers: header, body: _body);
    if(response.statusCode == 200){
      List listResponde = json.decode(response.body);

      boletos = List<Boletos>();
      for(Map map in listResponde){
        Boletos b = Boletos.fromJson(map);
        boletos.add(b);
      }
      return boletos;
    }else
      return null;
  }

}