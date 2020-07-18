import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:grizzly_io/io_loader.dart';

class TablePage extends StatefulWidget {
  @override
  TablePageState createState() {
    return TablePageState();
  }
}

class TablePageState extends State<TablePage> {
  List<List<dynamic>> data = [];
  int total;
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _hasValidMime = false;
  FileType _pickingType;
  String names;

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
          'TABLE',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('CSV', style: TextStyle(color: Colors.white)),
                color: Colors.blue[500],
                onPressed: () {
                  crearcsv(_path);
                  //csvUpload();
                },
              ),
              RaisedButton(
                child: Text('CSVU', style: TextStyle(color: Colors.white)),
                color: Colors.blue[500],
                onPressed: () {
                  //crearcsv(_path);
                  csvUpload();
                },
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('$names').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    firstColumn(),
                    Column(
                        children: snapshot.data.documents
                            .map((doc) => buildItem(doc))
                            .toList()),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_openFileExplorer()},
        child: Icon(Icons.cloud_upload),
      ),
    );
  }

  void csvUpload() async {
    var split = _fileName.split('.');
    var cadena = split[0].toString();
    names = cadena;
    for (var i = 1; i < total; i++) {
      var datos;
      var param1;
      var param2;
      var param3;
      var param4;

      print(data);
      datos = data[i];
      param1 = datos[0];
      param2 = datos[1];
      param3 = datos[2];
      param4 = datos[3];
      DocumentReference ref = await db.collection('$names').add({
        'name': param1,
        'param2': param2,
        'param3': param3,
        'param4': param4
      });

      setState(() => id = ref.documentID);
      print(ref.documentID);
    }

    print(names);
    DocumentReference nombres =
        await db.collection('Nombre').add({'nombre': names});
  }

  Widget buildItem(DocumentSnapshot doc) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(1.2),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            textDirection: TextDirection.ltr,
            children: <Widget>[
              (Text(
                "${doc.data['name']}",
              )),
              (Text("${doc.data['param2']}")),
              (Text("${doc.data['param3']}")),
              (Text("${doc.data['param4']}")),
            ]));
  }

  Widget firstColumn() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.blue[500],
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(1.2),
        ),
        child: Row(children: <Widget>[
          SizedBox(
            width: 30,
          ),
          Text("ID", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 75,
          ),
          Text("Nombre", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 50,
          ),
          Text("Numer1", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("Numer2", style: TextStyle(color: Colors.white)),
        ]));
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(type: FileType.any);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  crearcsv(String path) async {
    final csv = await readCsv(path);
    data = csv;
    total = data.length;
    setState(() {});
  }
}
