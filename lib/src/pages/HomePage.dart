import 'dart:math';
import 'package:flutter/material.dart';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:grizzly_io/io_loader.dart';

class FirestoreCRUDPage extends StatefulWidget {
  @override
  FirestoreCRUDPageState createState() {
    return FirestoreCRUDPageState();
  }
}

class FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal[200],
        title: Text('Firestore Table',style:TextStyle(fontStyle: FontStyle.italic,letterSpacing: 5)),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          // Form(
          //   key: _formKey,
          //   child: buildTextFormField(),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
              RaisedButton(
                child: Text('CSV', style: TextStyle(color: Colors.white)),
                color: Colors.black,
                onPressed: () {
                  crearcsv(_path);
                  //csvUpload();
                },
              ),
              RaisedButton(
                child: Text('CSVU', style: TextStyle(color: Colors.white)),
                color: Colors.black,
                onPressed: () {
                  //crearcsv(_path);
                  csvUpload();
                },
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('CRUD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    firstColumn(),
                    Column(
                        children: snapshot.data.documents
                            .map((doc) => buildItem(doc))
                            .toList()
                    ),
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

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db
          .collection('CRUD')
          .add({'name': '$name 😎', 'todo': randomTodo()});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void csvUpload() async {
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
      DocumentReference ref = await db.collection('CRUD').add({
        'name': param1,
        'param2': param2,
        'param3': param3,
        'param4': param4
      });
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .document(doc.documentID)
        .updateData({'todo': 'please 🤫'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }

  String randomTodo() {
    final randomNumber = Random().nextInt(4);
    String todo;
    switch (randomNumber) {
      case 1:
        todo = 'Like and subscribe 💩';
        break;
      case 2:
        todo = 'Twitter @robertbrunhage 🤣';
        break;
      case 3:
        todo = 'Patreon in the description 🤗';
        break;
      default:
        todo = 'Leave a comment 🤓';
        break;
    }
    return todo;
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );
  }
  
  Widget buildItem(DocumentSnapshot doc){
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
             (Text("${doc.data['name']}",)),
               (Text("${doc.data['param2']}")),
               (Text("${doc.data['param3']}")),
               (Text("${doc.data['param4']}")),

        
       ])
);
  }
  Widget firstColumn(){

      return Container(
  decoration: BoxDecoration(
    color: Colors.teal,
    border: Border.all(
      color: Colors.grey,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(1.2),
  ),
      child: Row(
       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
             SizedBox(width: 30,),

             Text("ID",style: TextStyle(color: Colors.white)),
             SizedBox(width: 75,),
               Text("Nombre",style: TextStyle(color: Colors.white)),
             SizedBox(width: 50,),
               Text("Numer1",style: TextStyle(color: Colors.white)),
             SizedBox(width: 30,),

               Text("Numer2",style: TextStyle(color: Colors.white)),

        
       ])
);
  }
  // Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,

  //       children: <Widget>[
  //            (Text("${doc.data['name']}",)),
  //              (Text("${doc.data['param2']}",textAlign:TextAlign.start)),
  //              (Text("${doc.data['param3']}")),
  //              (Text("${doc.data['param4']}")),

        
  //       ]);
  //  sortColumnIndex: 2,
  //               sortAscending: false,
  //               columns: [
  //                 DataColumn(label: Text("Nombre")),
  //                 DataColumn(label: Text("Apellido")),
  //                 DataColumn(label: Text("Años"),),
  //               ],
  //               rows: [
  //                 DataRow(
  //                   selected: true,
  //                  cells: [
  //                   DataCell(Text("${doc.data['name']}")),
  //                   DataCell(Text("${doc.data['param2']}")),
  //                   DataCell(Text("${doc.data['param3']}"))
  //                 ])
  //               ],
  // Card buildItem(DocumentSnapshot doc) {
  //   return Card(
  //     elevation: 0,
  //     color: Colors.transparent,
  //     child: Padding(
  //       padding: const EdgeInsets.all(3),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             'name: ${doc.data['name']}' +
  //                 '        ' +
  //                 'param2: ${doc.data['param2']}' +
  //                 '        ' +
  //                 'param2: ${doc.data['param3']}' +
  //                 '        ' +
  //                 'param2: ${doc.data['param4']}',
  //             style: TextStyle(fontSize: 12),
  //           ),
  //           SizedBox(height: 12),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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