import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue, // Set your desired primary color here
        fontFamily: 'Roboto',
      ),
      home: WeatherHome(),
    );
  }
}

// ... rest of the code ...

class WeatherHome extends StatefulWidget {
  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  String cityName = "";
  String country = "";
  String weatherDescription = "";
  double temperature = 0.0;
  bool isLoading = false;

  Future<void> getWeatherData(String city, String countryCode) async {
    final apiKey = "89c4b7b8e9d646c4bc3173950232107";
    final url =
        "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city,$countryCode";

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final location = data['location'];
        final current = data['current'];

        setState(() {
          cityName = location['name'];
          country = location['country'];
          weatherDescription = current['condition']['text'];
          temperature = current['temp_c'];
        });
      } else {
        print("Gagal mengambil data cuaca: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Cuaca"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Masukkan nama kota",
              ),
              onChanged: (value) {
                cityName = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Masukkan kode negara (contoh: id, us, gb)",
              ),
              onChanged: (value) {
                country = value;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      getWeatherData(cityName, country);
                    },
              child: Text("Dapatkan Cuaca", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kota: $cityName",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Negara: $country",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Suhu: ${temperature.toStringAsFixed(1)}°C",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Cuaca: $weatherDescription",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
