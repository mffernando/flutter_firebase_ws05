import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'addProduct.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
// TODO: implement createState
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('products')
              .orderBy('name')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data.documents[index];
                  Map<String, dynamic> product = document.data;
                  String documentId = document.documentID;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product['name'],
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(product['brand']),
                            Text(product['amount'].toString()),
                            Text(product['validity']),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Atenção"),
                                            content: Text(
                                                "Tem certeza que deseja remover o produto?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("Sim"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  document.reference.delete();
                                                  setState(() {});
                                                  Scaffold.of(this.context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "${product['name']} deletado com sucesso")));
                                                },
                                              ),
                                              FlatButton(
                                                child: Text("Não"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Deletar",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      print("Document ID: " + documentId);
                                      return AddProduct(
                                          product['name'],
                                          product['brand'],
                                          product['amount'],
                                          product['validity'],
                                          documentId,
                                          true);
                                    }));
                                  },
                                  child: Text(
                                    "Editar",
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}