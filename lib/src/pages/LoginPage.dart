import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tes/src/preferencias_usuario.dart/preferencias_usuario.dart';
import 'package:tes/src/providers/usuario_provider.dart';
import 'package:tes/src/utils/utils.dart';

import '../bloc/login_bloc.dart';
import '../bloc/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PreferenciasUsuario _prefs = new PreferenciasUsuario();
  bool passwordVisible = true;
  bool isLoading = false;
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[_loginForm(context)],
    ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.blue[800],
            Colors.blue[700],
            Colors.blue[600],
            Colors.blue[400],
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.80,
              width: size.width * 2,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 50.0),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 3.0,
                        offset: Offset(0.0, 5.0),
                        spreadRadius: 3.0)
                  ]),
              child: Column(
                children: <Widget>[
                  Text(
                    'CCP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 100.0),
                  _crearEmail(bloc),
                  SizedBox(height: 20.0),
                  _crearPassword(bloc),
                  SizedBox(height: 20.0),
                  _crearBoton(bloc)
                ],
              ),
            ),
            SizedBox(
              height: 100.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            cursorColor: Colors.teal,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.white),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.white),
              errorText: snapshot.error,
            ),
            controller: _usernameController,
            focusNode: _usernameFocus,
            onChanged: bloc.changeEmail,
            onSubmitted: (term) {
              _fieldFocusChange(context, _usernameFocus, _passwordFocus);
            },
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: passwordVisible,
            cursorColor: Colors.teal,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white),
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                errorText: snapshot.error,
                suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    })),
            controller: _passwordController,
            focusNode: _passwordFocus,
            onSubmitted: (term) {
              _login(context, bloc);
            },
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidarStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return isLoading
            ? CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              )
            : RaisedButton(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 120.0, vertical: 15.0),
                  child: Text('Ingresar'),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Theme.of(context).primaryColor,
                textColor: Colors.black,
                onPressed:
                    snapshot.hasData ? () => _login(context, bloc) : null,
              );
      },
    );
  }

  _login(BuildContext context, LoginBloc bloc) async {
    String mensaje;

    Map info = await usuarioProvider.login(
      bloc.email,
      bloc.password,
    );

    if (info['mensaje'] == 'EMAIL_NOT_FOUND') {
      mensaje = 'Correo Incorrecto';
    } else if (info['mensaje'] == 'INVALID_PASSWORD') {
      mensaje = 'Contraseña Incorrecta';
    }

    if (info['ok']) {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
      _prefs.currentMail = bloc.email;
    } else {
      mostrarAlerta(context, mensaje);
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
