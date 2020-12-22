import 'dart:async';

import 'package:formsvalidations/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  //Escuchamos los cambios del stream --> recuperamos datos del mismo

  Stream<String> get emailStream => _emailController.stream.transform(emailValidator);
  
  //Al hacer el mixing podemos acceder a su password validator, que es un Stream Transformer
  Stream<String> get passwordStream => _passwordController.stream.transform(passwordValidator);

  //Combinamos los dos streams, si tenemos datos en ambos entonces devolvemos true 
  Stream<bool> get formValidStream => 
    Rx.combineLatest2(emailStream, passwordStream,(e,p) => true);

  //Obtener el último valor de los streams
  String get emailValue => _emailController.value;
  String get passwordvalue => _passwordController.value;

  //Cerramos el stream cuando ya no escuchemos
  dispose(){
    //Con el ? decimos que si es nulo, no ejecute el método close
    _emailController?.close();
    _passwordController?.close();

  }
}