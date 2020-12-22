
import 'dart:async';

class Validators {

  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length >= 6){
        sink.add(password);
      }else{
        sink.addError('La contraseña debe ser mayor a 6 caracteres');
      }
    }
  );

  final emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp expreg = new RegExp(pattern);
      if(expreg.hasMatch(email)){
        sink.add(email);
      }else{
        sink.addError('No es un email válido');
      } 
    }
  );
}