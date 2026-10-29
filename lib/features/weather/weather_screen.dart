import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/feature.dart';
import '../../core/widgets/future_view.dart';
import '../../core/widgets/info_row.dart';
import 'weather_service.dart';

final weatherFeature = Feature(
  title: 'Clima en RD',
  subtitle: 'Cómo estará el día en Santo Domingo',
  icon: Icons.wb_sunny,
  builder: (_) => const WeatherScreen(),
);

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherToday> _future = fetchWeather();

  void _reload() => setState(() => _future = fetchWeather());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en RD'),
        actions: [
          IconButton(
            onPressed: _reload,
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureView<WeatherToday>(
        future: _future,
        onRetry: _reload,
        builder: (context, weather) => _WeatherView(weather: weather),
      ),
    );
  }
}

IconData _iconFor(int code) {
  if (code == 0 || code == 1) return Icons.wb_sunny;
  if (code == 2) return Icons.wb_cloudy;
  if (code == 3) return Icons.cloud;
  if (code == 45 || code == 48) return Icons.blur_on;
  if (code >= 51 && code <= 67) return Icons.umbrella;
  if (code >= 71 && code <= 77) return Icons.ac_unit;
  if (code >= 80 && code <= 82) return Icons.grain;
  if (code >= 95) return Icons.flash_on;
  return Icons.cloud_queue;
}

class _WeatherView extends StatelessWidget {
  const _WeatherView({required this.weather});

  final WeatherToday weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Santo Domingo, República Dominicana',
            style: theme.textTheme.titleMedium),
        Text(longDate(weather.date)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(_iconFor(weather.code),
                  size: 72, color: scheme.onPrimaryContainer),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°C',
                      style: theme.textTheme.displayMedium
                          ?.copyWith(color: scheme.onPrimaryContainer),
                    ),
                    Text(
                      weather.description,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: scheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                InfoRow(label: 'Máxima', value: '${weather.tempMax.round()}°C'),
                InfoRow(label: 'Mínima', value: '${weather.tempMin.round()}°C'),
                InfoRow(
                  label: 'Probabilidad de lluvia',
                  value: weather.rainChance == null
                      ? 'Sin dato'
                      : '${weather.rainChance}%',
                ),
                InfoRow(label: 'Humedad', value: '${weather.humidity}%'),
                InfoRow(
                  label: 'Viento',
                  value: '${weather.windKmh.round()} km/h',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
