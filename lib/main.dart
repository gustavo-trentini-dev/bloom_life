import 'dart:convert';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bloom_life/new_tree.dart';
import 'package:bloom_life/list_tree.dart';
import 'package:bloom_life/request.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF228B22),
      ),
      home: CreateToDo(),
    );
  }
}

class CreateToDo extends StatefulWidget {
  CreateToDoState createState() => CreateToDoState();
}

class CreateToDoState extends State<CreateToDo> {
  void initState() {
    _getNow();
    var cron = new Cron();
    cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
      _getNow();
    });
    super.initState();
  }

  String serverResponse = 'Server response';

  final items = {
    'd': 'Dia',
    's': 'Semana',
    'm': 'Mês',
  };

  int planta_id = 0;
  String nome = '';
  var luminosity;
  var umidity;
  var temperature;
  String time = 'd';

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          myAppBar(context),
          Container(
            height: 120,
            width: 120,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: ListView(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  nome,
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  'Luminosidade: ' + (luminosity['valor'] ? luminosity['valor'] : ''),
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 10, bottom: 10),
                child: Text(
                  'Umidade: ' + (umidity['valor'] ? umidity['valor'] : ''),
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    'Temperatura: ' + (temperature['valor'] ? temperature['valor'] : '') + 'º C',
                    style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: DropdownButton(
                  items: items.entries
                      .map<DropdownMenuItem<String>>(
                          (MapEntry<String, String> e) =>
                              DropdownMenuItem<String>(
                                value: e.key,
                                child: Text(e.value),
                              ))
                      .toList(),
                  onChanged: (String newKey) {
                    print(newKey);
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: 'newTree',
              backgroundColor: Color(0xFF228B22),
              child: Icon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewTree()),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment(0.1, 1),
            child: FloatingActionButton(
              heroTag: 'listTrees',
              backgroundColor: Color(0xFF228B22),
              child: Icon(
                FontAwesomeIcons.list,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListTree()),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment(-0.8, 1),
            child: FloatingActionButton(
              heroTag: 'camera',
              backgroundColor: Color(0xFF228B22),
              child: Icon(
                FontAwesomeIcons.camera,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestTest()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget myAppBar(context) {
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
                      //
                    }),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Text(
                  'Bloom Life',
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

  _getNow() async {
    Response response = await get(_localhost() + 'getAtual');
    setState(() {
      var resp = json.decode(response.body);
      print(resp);
      planta_id = resp['id'];
      nome = resp['nome'].toString();

      _getHistoric();
    });
  }

  _getHistoric() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String params = '{"time": "' + this.time + '", "planta_id": "' + this.planta_id.toString() + '"}';
    Response response = await post(_localhost() + 'getHistoric',
        headers: headers, body: params);
    setState(() {
      var retorno = json.decode(response.body);

      umidity =  retorno['umidade'];
      luminosity =  retorno['luminosidade'];
      temperature =  retorno['temperatura'];
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
