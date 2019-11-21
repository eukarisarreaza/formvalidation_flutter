import 'dart:convert';

import 'package:formvalidation/src/preferencia_usuario/preferencia_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider{

  final String _firebaseToken= 'AIzaSyCxXIuQzx-rIXsxOGNO9hD_fupwPUDIgZc';
  final _prefs= new PreferenciasUsuario();


  Future login(String email, String password) async {
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken': true
    };
    final res= await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);

    if(decodeResp.containsKey('idToken')){
      //TODO almacenar el token en local
      _prefs.token= decodeResp['idToken'];
      return {'ok' : true, 'token': decodeResp['idToken']};
    }else{
      return {'ok' : false, 'mensaje': decodeResp['error']['message']};
    }
  }

  Future nuevoUsuario(String email, String password) async {
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken': true
    };
    final res= await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(res.body);
    print(decodeResp);

    if(decodeResp.containsKey('idToken')){
      //TODO almacenar el token en local
      _prefs.token= decodeResp['idToken'];
      return {'ok' : true, 'token': decodeResp['idToken']};
    }else{
      return {'ok' : false, 'mensaje': decodeResp['error']['message']};
    }
  }

}