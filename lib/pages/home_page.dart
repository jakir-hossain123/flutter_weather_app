import 'package:flutter/material.dart';

import '../model/weather_model.dart';
import '../weather_service/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityController = TextEditingController();

  final WeatherService weatherService = WeatherService();

  WeatherModel? weather;

  bool isLoading = false;

  String? errorMessage;

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }
  Future<void> searchWeather() async {
    final city = cityController.text.trim();

    if (city.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await weatherService.getWeather(city);

      setState(() {
        weather = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        weather = null;
      });
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
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                hintText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: searchWeather,
                child: const Text('Search'),
              ),
            ),

            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator(),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),

            if (weather != null)
              Card(
                margin: const EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        weather!.cityName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '${weather!.temperature}°C',
                        style: const TextStyle(fontSize: 40),
                      ),

                      const SizedBox(height: 10),

                      Text(weather!.description),

                      const SizedBox(height: 10),

                      Text('Humidity: ${weather!.humidity}%'),

                      Text('Wind: ${weather!.windSpeed} m/s'),
                    ],
                  ),
                ),
              ),
          ],
        ),

      ),
    );
  }
}