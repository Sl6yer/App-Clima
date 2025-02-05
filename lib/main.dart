import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _temperature; // Variaveis para armazenar os dados da API
  String? _tempMin;
  String? _tempMax;
  String? _local;
  String? _humidity;
  String? _wind;
  String? _clouds;

  final String _apiKey = 'b4c20b313c0b6d8a70e406f9bfbc837c'; //Key da API
  final String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather?lat=33.44&lon=-94.04&appid=b4c20b313c0b6d8a70e406f9bfbc837c&units=metric'; // URL da API
  final double _latitude = -14.2350;
  final double _longitude = -51.9253;

  Future<void> _fetchWeather() async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=-8&lon=-50&appid=b4c20b313c0b6d8a70e406f9bfbc837c&units=metric"; //Função para buscar os Dados da API

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        print("Dados recebidos: ${response.body}");
        _temperature = data['main']['temp'].toInt().toString();
        _tempMin = data['main']['temp_min'].toInt().toString();
        _tempMax = data['main']['temp_max'].toInt().toString();
        _local = data['name'].toString();
        _humidity = data['main']['humidity'].toString();
        _wind = data['wind']['speed'].toString();
        _clouds = data['clouds']['all'].toString();
      });
    } else {
      print("Erro na requisição: ${response.statusCode}");
      throw Exception('Erro ao carregar dados do clima');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Chamada a API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clima"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$_local",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          Container(
            child: Center(
              child: Text(
                "$_temperature ℃",
                style: TextStyle(
                  fontSize: 85.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Min Temp $_tempMin℃",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Max Temp $_tempMax℃",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildContainer("$_humidity", "humidity"),
                  SizedBox(
                    width: 20,
                  ),
                  buildContainer("$_wind", "wind"),
                  SizedBox(
                    width: 20,
                  ),
                  buildContainer("$_clouds", "cloud"),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              _fetchWeather();
            },
            child: Text(
              "Atualizar",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent,
    );
  }
}

Map<String, IconData> iconMap = {
  'wind': Icons.air,
  'cloud': Icons.cloud,
  'humidity': Icons.water_drop,
};

Widget buildContainer(String text, String icon) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.all(19.0),
    child: Column(
      children: [
        Icon(iconMap[icon]),
        Text(text, style: TextStyle(fontSize: 18.0)),
      ],
    ),
  );
}
