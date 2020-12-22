import 'package:flutter/material.dart';
import 'package:formsvalidations/blocs/provider.dart';
import 'package:formsvalidations/pages/home_page.dart';
import 'package:formsvalidations/pages/login_page.dart';
import 'package:formsvalidations/pages/producto_page.dart';
import 'package:formsvalidations/pages/registro_page.dart';
import 'package:formsvalidations/sharedpreferences/userprefs.dart';
 
void main() async{
  //Arrancamos las preferencias de usuario para guardar el token
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login'   : (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home'    : (BuildContext context) => HomePage(),
          'product' : (BuildContext context) => ProductoPage(),
        },
        //tema de la aplicación
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      )
    );
  }
}