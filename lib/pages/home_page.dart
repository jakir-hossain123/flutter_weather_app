import 'package:flutter/material.dart';

import '../model/weather_model.dart';
import '../service/location_service.dart';
import '../service/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityController = TextEditingController();

  final WeatherService weatherService = WeatherService();
  final LocationService locationService = LocationService();

  WeatherModel? weather;

  bool isLoading = false;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCurrentLocationWeather();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }
  Future<void> loadCurrentLocationWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final position = await locationService.getCurrentLocation();

      final result = await weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        weather = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: cityController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => searchWeather(),
                decoration: InputDecoration(
                  hintText: "Search City",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: searchWeather,
                    icon: const Icon(Icons.send),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
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
                Container(
                  height: 400,
                  width: 300,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff4facfe),
                        Color(0xff00f2fe),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          weather!.cityName,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
          
                        const SizedBox(height: 10),
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            'https://openweathermap.org/img/wn/${weather!.icon}@4x.png',
                            fit: BoxFit.contain,
                          ),
          
                        ),
                        const SizedBox(height: 10),
          
                        Text(
                          '${weather!.temperature.round()}°C',
                          style: const TextStyle(fontSize: 50),
                        ),
          
                        const SizedBox(height: 10),
          
                        Text(weather!.description),
          
                        const SizedBox(height: 10),

                        Text('Humidity: ${weather!.humidity}%',
                        style: TextStyle(),
                        ),
          
                        Text('Wind: ${weather!.windSpeed} m/s'),
                      ],
                    ),
                  ),
                ),
          
            ],
          ),
        ),

      ),
    );
  }
}