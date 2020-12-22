import 'dart:convert';

import 'package:formsvalidations/sharedpreferences/userprefs.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _apiKey = 'AIzaSyBjIEMwcPL9G1MewCBvl0RHAwjBYE6N8nw';
  final _prefs = new UserPreferences();

  Future<Map<String,dynamic>> createUser(String email, String password) async{
    final String _authUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey';
    final authData ={
      'email'             : email, 
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      _authUrl,
      body: json.encode(authData)
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    //Comprobamos y tratamos la respuesta
    if(decodedResp.containsKey('idToken')){
      //La información mandada es correcta, el usuario se añade a firebase
      //Añadimos token a los _prefs
      _prefs.token = decodedResp['idToken'];
      return {'ok': true};
    }else{
      return{'ok' : false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String,dynamic>> doLogin(String email, String password) async {
    final String _loginUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';
    final loginData = {
      'email': email, 
      'password': password,
      'returnSecureToken' : true
    };
    final resp = await http.post(
      _loginUrl,
      body: json.encode(loginData),
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if(decodedResp.containsKey('idToken')){
      _prefs.token = decodedResp['idToken'];
      return {'ok': true};
    }else{
      return{'ok' : false, 'mensaje': decodedResp['error']['message']};
    }
  }
}