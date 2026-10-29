import 'package:flutter/material.dart';

import '../../core/feature.dart';
import '../../core/text_utils.dart';
import '../../core/widgets/future_view.dart';
import '../../core/widgets/search_field.dart';
import 'gender_service.dart';

final genderFeature = Feature(
  title: 'Género por nombre',
  subtitle: 'Escribe un nombre y predice su género',
  icon: Icons.wc,
  builder: (_) => const GenderScreen(),
);

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  Future<GenderResult>? _future;
  String _name = '';

  void _search(String name) {
    setState(() {
      _name = name;
      _future = fetchGender(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Género por nombre')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(label: 'Nombre', hint: 'Ej. Irma', onSearch: _search),
            const SizedBox(height: 16),
            Expanded(
              child: FutureView<GenderResult>(
                future: _future,
                emptyMessage: 'Escribe un nombre para predecir su género.',
                onRetry: () => _search(_name),
                builder: (context, result) => _GenderPanel(result: result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderPanel extends StatelessWidget {
  const _GenderPanel({required this.result});

  final GenderResult result;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = result.isMale ? Colors.blue.shade700 : Colors.pink.shade600;
    final label = switch (result.gender) {
      'male' => 'Masculino',
      'female' => 'Femenino',
      _ => 'Sin datos suficientes',
    };
    final icon = switch (result.gender) {
      'male' => Icons.male,
      'female' => Icons.female,
      _ => Icons.help_outline,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 96, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            capitalize(result.name),
            style: textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
          Text(
            label,
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          if (result.gender != null) ...[
            const SizedBox(height: 12),
            Text(
              'Probabilidad: ${(result.probability * 100).round()}% '
              '(${result.count} registros)',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
