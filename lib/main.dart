import 'package:flutter/material.dart';
import 'package:tes/src/pages/HomePage.dart';
import 'package:tes/src/pages/LoginPage.dart';
import 'package:tes/src/bloc/provider.dart';
import 'package:tes/src/pages/csvPage.dart';
import 'package:tes/src/pages/testPage.dart';
import 'package:tes/src/pages/userProfilePage.dart';
import 'package:tes/src/preferencias_usuario.dart/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => FirestoreCRUDPage(),
          'test': (BuildContext context) => TablePage(),
          'csv': (BuildContext context) => CsvPage(),
          'profile': (BuildContext context) => DetailPage()
        },
        theme: ThemeData(primaryColor: Colors.white),
      ),
    );
  }
}
