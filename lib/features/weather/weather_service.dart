import '../../core/api_client.dart';

// Santo Domingo, República Dominicana.
const _latitude = '18.4861';
const _longitude = '-69.9312';

class WeatherToday {
  const WeatherToday({
    required this.date,
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.humidity,
    required this.windKmh,
    required this.rainChance,
    required this.code,
  });

  final DateTime date;
  final double temperature;
  final double tempMax;
  final double tempMin;
  final int humidity;
  final double windKmh;
  final int? rainChance;
  final int code;

  /// Códigos WMO que devuelve Open-Meteo.
  String get description {
    if (code == 0) return 'Despejado';
    if (code == 1) return 'Mayormente despejado';
    if (code == 2) return 'Parcialmente nublado';
    if (code == 3) return 'Nublado';
    if (code == 45 || code == 48) return 'Niebla';
    if (code >= 51 && code <= 57) return 'Llovizna';
    if (code >= 61 && code <= 67) return 'Lluvia';
    if (code >= 71 && code <= 77) return 'Nieve';
    if (code >= 80 && code <= 82) return 'Chubascos';
    if (code >= 95) return 'Tormenta eléctrica';
    return 'Condición no identificada';
  }

  factory WeatherToday.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    double first(String key) => ((daily[key] as List).first as num).toDouble();

    return WeatherToday(
      date: DateTime.parse((daily['time'] as List).first as String),
      temperature: (current['temperature_2m'] as num).toDouble(),
      tempMax: first('temperature_2m_max'),
      tempMin: first('temperature_2m_min'),
      humidity: (current['relative_humidity_2m'] as num).round(),
      windKmh: (current['wind_speed_10m'] as num).toDouble(),
      rainChance:
          ((daily['precipitation_probability_max'] as List).first as num?)
              ?.round(),
      code: (current['weather_code'] as num).toInt(),
    );
  }
}

Future<WeatherToday> fetchWeather() async {
  final json = await getJson(
    Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': _latitude,
      'longitude': _longitude,
      'current': 'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
      'daily': 'temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'America/Santo_Domingo',
      'forecast_days': '1',
    }),
  );
  return WeatherToday.fromJson(json as Map<String, dynamic>);
}
