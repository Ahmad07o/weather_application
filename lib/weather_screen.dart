import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/additional_info_item.dart';
import 'package:weather_application/hourly_forcast_item.dart';
import 'package:weather_application/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temperature = 0;

  final String cityName = "Lahore";

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherApiKey",
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "unexpeted error occur";
      }
      return data;

      //
    } catch (e) {
      throw e.toString();
    }
    // print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTem = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final humidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final windSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(16),
                  ),
                  elevation: 10,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTem C°',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              SizedBox(height: 12),

                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 40,
                              ),
                              SizedBox(height: 12),

                              Text(currentSky, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Weather forcast ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i <= 4; i++)
                //         HourlyForcastItem(
                //           time: data['list'][i + 1]['dt'].toString(),
                //           icon:
                //               data['list'][i + 1]['main']['temp'] == 'Rain' ||
                //                   data['list'][i + 1]['main']['temp'] ==
                //                       'Clouds'
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temprature: data['list'][i + 1]['main']['temp']
                //               .toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (BuildContext, index) {
                      return HourlyForcastItem(
                        time: data['list'][index + 1]['dt'].toString(),
                        icon:
                            data['list'][index + 1]['main']['temp'] == 'Rain' ||
                                data['list'][index + 1]['main']['temp'] ==
                                    'Clouds'
                            ? Icons.cloud
                            : Icons.sunny,
                        temprature: data['list'][index + 1]['main']['temp']
                            .toString(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    additional_Info_item(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: humidity.toString(),
                    ),
                    additional_Info_item(
                      icon: Icons.air,
                      label: "Wind speed",
                      value: windSpeed.toString(),
                    ),
                    additional_Info_item(
                      icon: Icons.beach_access,
                      label: "preassure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
