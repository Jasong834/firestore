import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreCRUDPage extends StatefulWidget {
  @override
  FirestoreCRUDPageState createState() {
    return FirestoreCRUDPageState();
  }
}

class FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  final db = Firestore.instance;
  String nombre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: Text(
          'Prueba',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.perm_identity),
              color: Colors.white,
              iconSize: 35,
              onPressed: () => [
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'profile', (Route<dynamic> route) => true)
                  ]),
          IconButton(
              icon: Icon(Icons.power_settings_new),
              color: Colors.white,
              iconSize: 35,
              onPressed: () => [
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'login', (Route<dynamic> route) => false)
                  ]),
        ],
      ),
      body: Container(
        child: _crearListado(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_upload),
        onPressed: () => {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('test', (Route<dynamic> route) => true)
        },
        backgroundColor: Colors.blue[500],
      ),
    );
  }

  _crearListado(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('Nombre').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final datos = snapshot.data.documents;
          return ListView.builder(
              itemCount: datos.length,
              itemBuilder: (context, i) => crearItem(context, datos[i]));
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget crearItem(BuildContext context, dynamic doc) {
    return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${doc.data['nombre']}'),
            onTap: () => {
              nombre = doc.data['nombre'],
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'csv', (Route<dynamic> route) => true,
                  arguments: nombre)
            },
          )
        ],
      ),
    );
  }
}
