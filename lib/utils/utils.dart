import 'package:flutter/material.dart';

bool isANumber (String value){
  if(value.isEmpty) return false;
  final number = num.tryParse(value);
  return (number == null) ? false : true;
}

void showAlert (BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(mensaje),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}