import 'package:flutter/material.dart';
import 'package:formsvalidations/blocs/provider.dart';
import 'package:formsvalidations/providers/usuario_provider.dart';
import 'package:formsvalidations/widgets/login_header.dart';

class RegistroPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegistroPage> {

  bool seePassword;
  final usuarioProvider = UsuarioProvider();

  @override
  void initState() {
    super.initState();
    seePassword = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LoginHeader(),
          //Los campos de texto dentro de un scroll para que no los tape el teclado
          _loginForm(context),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context){

    final size = MediaQuery.of(context).size;
    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget> [
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                )
              ]
            ),
            child: Column(
              children: <Widget> [
                Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height:60.0),
                _createEmailInput(bloc),
                SizedBox(height:20.0),
                _createPassword(bloc),
                SizedBox(height:60.0),
                _createButton(bloc,context),
              ],
            )
          ),
          FlatButton(
            child: Text('¿Ya tienes cuenta?'),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
          SizedBox(height: 100.0),
        ],
      )
    );
  }

  Widget _createEmailInput(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              counterText: (seePassword)
                        ? snapshot.data
                        : null,
              /*Cuando nuestro stream está emitiendo errores no tiene data si no errores, el 
              error que el validator está metiendo en el stream*/ 
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _createButton(LoginBloc bloc, BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20.0),
      child: Row(
        children: [
          StreamBuilder(
            stream: bloc.formValidStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return Expanded(
                child: RaisedButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal:80.0, vertical: 15.0),
                    child: Text('Login'),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0.0, 
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  //Habilitamos el botón cuando el form sea correcto
                  //Cuando la mezcla de los stream tenga datos
                  //Cada stream por individual no tiene datos hasta que no es correcto
                  onPressed: (snapshot.hasData)
                          ? () => _doRegister(bloc, context)
                          : null,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              (seePassword)
                 ? Icons.lock_open
                 : Icons.lock_outline,
              color: Colors.deepPurple),
            onPressed: (){
              setState(() {
                seePassword = !seePassword;
              });
            },
          ),
        ],
      ),
    );
  }

  /*Para obtener los valores del formulario, pillamos el último valor
  emitido por los BehaviorSubject*/ 
  _doRegister(LoginBloc bloc, BuildContext context) async {
    final response = await usuarioProvider.createUser(bloc.emailValue, bloc.passwordvalue);
    print(response);
  }
}