import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bloom_life/trees.dart';

class ListTree extends StatefulWidget {
  ListTree();

  @override
  _ListTreeState createState() => _ListTreeState();
}

class _ListTreeState extends State<ListTree> {
  @override
  void initState() {
    _getTrees();
    super.initState();
  }

  List trees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _myAppBar(),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height - 80,
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    'Árvore',
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: new ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: trees == null ? 0 : trees.length,
                    itemBuilder: (BuildContext context, int index){
                      var parsedDate = DateTime.parse(trees[index]['nascimento']);
                      String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                      return GestureDetector(
                        child: new ListTile(
                      title: new Text(trees[index]['id'] + ' - ' + trees[index]["nome"]),
                      subtitle: new Text(trees[index]['especie'] + ' - ' + formattedDate ),
                      ),
                        onTap: () =>
                        _doSomething(trees[index]["id"])
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Voltar",
                          style: TextStyle(color: Colors.white),
                        )),
                    // This button results in adding the contact to the database
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _myAppBar() {
    return Container(
      height: 80.0,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xFF228B22),
              const Color(0xFF98FB98),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Text(
                      'Cadastrar Árvore',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  _getTrees() async {
    Response response = await get(_localhost() + 'getTrees');
    setState(() {
      print(response.body);
      trees = JsonDecoder().convert(response.body);
      print(trees);
    });
  }

  _doSomething(planta_id) async{
    Map<String, String> headers = {"Content-type": "application/json"};
    String params = '{"id": "' + planta_id + '"}';
    Response response = await post(_localhost() + 'updateAtual', headers: headers, body: params);
    setState(() {
      print(response.body);
      Toast.show(response.body, context, duration: Toast.LENGTH_LONG);
    });
  }

  String _localhost() {
    if (Platform.isAndroid)
//      return 'http://177.44.248.24:3000/';
      return 'http://10.0.2.2:3000/';
    else // for iOS simulator
//      return 'http://177.44.248.24:3000/';
      return 'http://localhost:3000/';
  }
}
