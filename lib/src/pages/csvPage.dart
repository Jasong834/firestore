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
  String names;

  @override
  Widget build(BuildContext context) {
    final String prodData = ModalRoute.of(context).settings.arguments;
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
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('$prodData').snapshots(),
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
    );
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
}
