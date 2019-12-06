import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloom_life/especie.dart';
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
  String specie;
  String specieId = '';
  List<Especie> species = [];
  var _name = TextEditingController();
  var _umidity = TextEditingController();
  var _luminosity = TextEditingController();
  var _temp_max = TextEditingController();
  var _temp_min = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSpecies();
    _name = new TextEditingController(text: '');
    _umidity = new TextEditingController(text: '');
    _luminosity = new TextEditingController(text: '');
    _temp_max = new TextEditingController(text: '');
    _temp_min = new TextEditingController(text: '');
  }

  String serverResponse = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    'Espécies cadastradas',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 10.0, right: 16.0, bottom: 16.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: new Text("Espécies cadastradas"),
                    value: specie,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        print(newValue.toString());
                        _getSpecie(newValue.toString());
                      });
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
                    controller: _name,
                    onChanged: (String newValue) {
                      specieName = newValue.toString();
                    },
                    decoration: InputDecoration(labelText: "Espécie: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _umidity,
                    onChanged: (String newValue) {
                      umidade = newValue.toString();
                    },
                    decoration: InputDecoration(labelText: "Umidade: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _luminosity,
                    decoration: InputDecoration(labelText: "Luminosidade: "),
                    onChanged: (String newValue) {
                      luminosidade = newValue.toString();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _temp_min,
                    decoration:
                        InputDecoration(labelText: "Temp. Mínima (ºC): "),
                    onChanged: (String newValue) {
                      temp_min = newValue.toString();
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
                  child: TextField(
                    controller: _temp_max,
                    decoration:
                        InputDecoration(labelText: "Temp. Máxima (ºC): "),
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
                        color: Colors.orangeAccent,
                        onPressed: () {
                          specieId = '';
                          _name.text = '';
                          _umidity.text = '';
                          _luminosity.text = '';
                          _temp_max.text = '';
                          _temp_min.text = '';
                        },
                        child: const Text(
                          "Limpar",
                          style: TextStyle(color: Colors.white),
                        )),

                    RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          print(specieId);
                          if (specieId != '') {
                            _updateSpecie();
                          } else {
                            _saveSpecie();
                          }
                        },
                        child: new Text(
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

  _getSpecies() async {
    Response response = await get(_localhost() + 'getSpecies');
    setState(() {
      final json = JsonDecoder().convert(response.body);
      species = (json).map<Especie>((item) => Especie.fromJson(item)).toList();
    });
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
      Toast.show(response.body, context, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
    });
  }

  _updateSpecie() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String params = '{"nome": "' +
        _name.text +
        '", "umidade": "' +
        _umidity.text +
        '", "luminosidade": "' +
        _luminosity.text +
        '", "temp_min": "' +
        _temp_min.text +
        '", "temp_max": "' +
        _temp_max.text +
        '", "id": "' +
        this.specieId +
        '"}';
    print(params);
    Response response =
    await post(_localhost() + 'updateSpecie', headers: headers, body: params);
    setState(() {
      Toast.show(response.body, context, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
    });
  }

  _getSpecie(id) async {
    print(id);
    Map<String, String> headers = {"Content-type": "application/json"};
    String params = '{"id": "' + id + '"}';
    Response response =
        await post(_localhost() + 'getSpecie', headers: headers, body: params);
    setState(() {
      var retorno = json.decode(response.body);
      specieId = retorno['id'].toString();
      _name.text = retorno['nome'];
      _umidity.text = retorno['umidade'].toString();
      _luminosity.text = retorno['luminosidade'].toString();
      _temp_max.text = retorno['temp_max'].toString();
      _temp_min.text = retorno['temp_min'].toString();
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
