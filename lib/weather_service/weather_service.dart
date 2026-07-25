import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';
// https://api.openweathermap.org/data/2.5/weather?q=London&appid=bc6bc7a26aecd479f6ab811cc1b6d80c

class WeatherService {
  static const String apiKey = 'bc6bc7a26aecd479f6ab811cc1b6d80c';

  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> getWeather(String city) async {
    final uri = Uri.parse(
      '$baseUrl?q=$city&appid=$apiKey&units=metric',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return WeatherModel.fromJson(data);
    } else {
      final Map<String, dynamic> error = jsonDecode(response.body);

      throw Exception(error['message'] ?? 'Failed to load weather');
    }
  }
}