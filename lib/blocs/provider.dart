import 'package:flutter/material.dart';
import 'package:formsvalidations/blocs/login_bloc.dart';
export 'package:formsvalidations/blocs/login_bloc.dart';
import 'package:formsvalidations/blocs/productos_bloc.dart';
export 'package:formsvalidations/blocs/productos_bloc.dart';



class Provider extends InheritedWidget {

  //Los blocs a utilizar
  final loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  static Provider _instance;

  factory Provider({Key key, Widget child}){
    if(_instance == null){
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);
  

  //Sin singleton
  // Provider({Key key, Widget child})
  //   : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  /*Toma el contexto y busca*/
  static LoginBloc of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductosBloc productosBlocOf (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }
}