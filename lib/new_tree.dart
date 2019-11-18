import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bloom_life/main.dart';
import 'package:bloom_life/especie.dart';

class NewTree extends StatefulWidget {
  NewTree();

  @override
  _NewTreeState createState() => _NewTreeState();
}

class _NewTreeState extends State<NewTree> {
  String treeName, treeSpecie, treeBirth;
  List<Especie> species = [];

  getTreeName(treeName) {
    this.treeName = treeName;
  }

  getTreeSpecie(treeSpecie) {
    this.treeSpecie = treeSpecie;
  }

  getTreeBirth(treeBirth) {
    this.treeBirth = treeBirth;
  }

  @override
  void initState() {
    _getSpecies();
    super.initState();
  }

  String serverResponse = '';

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
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: new DropdownButton<String>(
                    hint: new Text("Selecione a espécie"),
                    value: treeSpecie,
                      isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        treeSpecie = newValue.toString();
                      });

                      print(treeSpecie);
                    },
                    items: species.map((Especie map) {
                      return new DropdownMenuItem<String>(
                        value: map.id.toString(),
                        child: new Text(map.nome,
                            style: new TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    onChanged: (String treeName) {
                      getTreeName(treeName);
                    },
                    decoration: InputDecoration(labelText: "Nome: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: "Nascimento: "),
                    onChanged: (String treeBirth) {
                      getTreeBirth(treeBirth);
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
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
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        )),
                    // This button results in adding the contact to the database
                    RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          _saveTree();
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(serverResponse),
                    ),
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

  _saveTree() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String params = '{"nome": "' + this.treeName +
    '", "especie": "' + this.treeSpecie +
    '", "nascimento": "' + this.treeBirth + '"}';
    Response response =
    await post(_localhost() + 'saveTree', headers: headers, body: params);
    setState(() {
      print('POST -> ' + response.body);
      serverResponse = response.body;
    });
  }

  _getSpecies() async {
    Response response = await get(_localhost() + 'getSpecies');
    setState(() {
      final json = JsonDecoder().convert(response.body);
      species = (json).map<Especie>((item) => Especie.fromJson(item)).toList();
      print(species);
    });
  }

  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000/';
    else // for iOS simulator
      return 'http://localhost:3000/';
  }
}
