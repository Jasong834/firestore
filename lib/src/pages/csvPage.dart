import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CsvPage extends StatefulWidget {
  @override
  CsvState createState() {
    return CsvState();
  }
}

class CsvState extends State<CsvPage> {
  final db = Firestore.instance;
  List test = [];
  var name;
  var campo1;
  var campo2;
  var campo3;
  var campo4;

  @override
  Widget build(BuildContext context) {
    final String prodData = ModalRoute.of(context).settings.arguments;
    name = prodData;
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
          title: Text('TABLE',
              style: TextStyle(fontSize: 25, color: Colors.white)),
        ),
        body: getData());
  }

  getData() {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection(name).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data.documents.map((doc) => buildItem(doc)).toList();
          return firstColumn();
        } else {
          return SizedBox();
        }
      },
    );
  }

  buildItem(DocumentSnapshot doc) {
    test.add(doc.data);
    //print(doc.data['param4']);
    campo1 = doc.data['name'];
    campo2 = doc.data['param2'];
    campo3 = doc.data['param3'];
    campo4 = doc.data['param4'];
    //print(campo2);

    return SizedBox(
      height: 0,
      width: 0,
    );
  }

  Widget firstColumn() {
    //print(test);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
            columns: [
              DataColumn(label: Text('Dato1')),
              DataColumn(label: Text('Dato2')),
              DataColumn(label: Text('Dato3')),
              DataColumn(label: Text('Dato4'))
            ],
            rows: test
                .map((e) => DataRow(cells: [
                      DataCell(Text(e['name'])),
                      DataCell(Text(e['param2'])),
                      DataCell(Text(e['param3'])),
                      DataCell(Text(e['param4']))
                    ]))
                .toList()),
      ),
    );
  }
}
