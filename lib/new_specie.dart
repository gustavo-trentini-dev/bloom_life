import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bloom_life/main.dart';
import 'package:toast/toast.dart';

class NewSpecie extends StatefulWidget {
  NewSpecie();

  @override
  _NewSpecieState createState() => _NewSpecieState();
}

class _NewSpecieState extends State<NewSpecie> {
  String specieName, umidade, luminosidade, temp_min, temp_max;

  @override
  void initState() {
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    'Nova Espécie\n Estado Ideal',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
                  child: TextField(
                    onChanged: (String newValue) {
                      specieName = newValue.toString();
                    },
                    decoration: InputDecoration(labelText: "Espécie: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    onChanged: (String newValue) {
                      umidade = newValue.toString();
                    },
                    decoration: InputDecoration(labelText: "Umidade: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: "Luminosidade: "),
                    onChanged: (String newValue) {
                      luminosidade = newValue.toString();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: "Temp. Mínima (ºC): "),
                    onChanged: (String newValue) {
                      temp_min = newValue.toString();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: "Temp. Máxima (ºC): "),
                    onChanged: (String newValue) {
                      temp_max = newValue.toString();
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
                          "Voltar",
                          style: TextStyle(color: Colors.white),
                        )),
                    // This button results in adding the contact to the database
                    RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          _saveSpecie();
                        },
                        child: const Text(
                          "Salvar",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
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
      width: MediaQuery.of(context).size.width,
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
                  'Cadastrar Espécie',
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

  _saveSpecie() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String params = '{"nome": "' +
        this.specieName +
        '", "umidade": "' +
        this.umidade +
        '", "luminosidade": "' +
        this.luminosidade +
        '", "temp_min": "' +
        this.temp_min +
        '", "temp_max": "' +
        this.temp_max +
        '"}';
    Response response =
        await post(_localhost() + 'saveSpecie', headers: headers, body: params);
    setState(() {
      print(response.body);
      Toast.show(response.body, context, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
    });
  }

  String _localhost() {
    if (Platform.isAndroid)
      return 'http://177.44.248.24:3000/';
//      return 'http://10.0.2.2:3000/';
    else // for iOS simulator
      return 'http://177.44.248.24:3000/';
//      return 'http://localhost:3000/';
  }
}
