import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Graph extends StatefulWidget {
  Graph();

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<charts.Series<dynamic, DateTime>> seriesList = List<charts.Series<dynamic, DateTime>>();
  final bool animate = false;

  List<TimeSeriesSales> umidade = List<TimeSeriesSales>();
  List<TimeSeriesSales> luminosidade = List<TimeSeriesSales>();
  List<TimeSeriesSales> temperatura = List<TimeSeriesSales>();

  @override
    void initState() {
    super.initState();
    _getGraph();
  }

  final items = {
    'd': 'Dia',
    's': 'Semana',
    'm': 'Mês',
  };

  String time = 'd';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: <Widget>[
          _myAppBar(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: new charts.TimeSeriesChart(
                seriesList,
                animate: animate,
                behaviors: [new charts.SeriesLegend()],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
            child: DropdownButton(
              isExpanded: true,
              items: items.entries
                  .map<DropdownMenuItem<String>>(
                      (MapEntry<String, String> e) => DropdownMenuItem<String>(
                            value: e.key,
                            child: Text(e.value),
                          ))
                  .toList(),
              hint: new Text('Selecione o período'),
              value: time,
              isDense: true,
              onChanged: (String newKey) {
                this.time = newKey;
                _getGraph();
              },
            ),
          ),
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
                  'Gráfico',
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

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(umidade, luminosidade, temperatura) {

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Umidade',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: umidade,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Luminosidade',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: luminosidade,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Temperatura',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: temperatura,
      )
    ];
  }

  _getGraph() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String params = '{"time": "' + this.time + '"}';
    Response response =
        await post(_localhost() + 'getGraph', headers: headers, body: params);
    setState(() {
      umidade = List<TimeSeriesSales>();
      luminosidade = List<TimeSeriesSales>();
      temperatura = List<TimeSeriesSales>();
      var retorno = json.decode(response.body);

      for (var element in retorno) {
        var ano = int.parse(element['date'].toString().substring(0, 4));
        var mes = int.parse(element['date'].toString().substring(5, 7));
        var dia = int.parse(element['date'].toString().substring(8, 10));
        var hora = int.parse(element['date'].toString().substring(11, 13));

        umidade.add(new TimeSeriesSales(new DateTime(ano, mes, dia, hora), element['umidade'].round()));
        luminosidade.add(new TimeSeriesSales(new DateTime(ano, mes, dia, hora), element['luminosidade'].round()));
        temperatura.add(new TimeSeriesSales(new DateTime(ano, mes, dia, hora), element['temperatura'].round()));
      }

      seriesList = _createSampleData(umidade, luminosidade, temperatura);
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

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
