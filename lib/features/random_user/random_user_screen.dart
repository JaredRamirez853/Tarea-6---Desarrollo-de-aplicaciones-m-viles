import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/feature.dart';
import '../../core/widgets/future_view.dart';
import '../../core/widgets/info_row.dart';
import 'random_user_service.dart';

final randomUserFeature = Feature(
  title: 'Persona aleatoria',
  subtitle: 'Nombre, foto, nacimiento y edad',
  icon: Icons.person_search,
  builder: (_) => const RandomUserScreen(),
);

class RandomUserScreen extends StatefulWidget {
  const RandomUserScreen({super.key});

  @override
  State<RandomUserScreen> createState() => _RandomUserScreenState();
}

class _RandomUserScreenState extends State<RandomUserScreen> {
  late Future<RandomPerson> _future = fetchRandomPerson();

  void _reload() => setState(() => _future = fetchRandomPerson());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Persona aleatoria')),
      body: FutureView<RandomPerson>(
        future: _future,
        onRetry: _reload,
        builder: (context, person) =>
            _PersonView(person: person, onNext: _reload),
      ),
    );
  }
}

class _PersonView extends StatelessWidget {
  const _PersonView({required this.person, required this.onNext});

  final RandomPerson person;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: ClipOval(
            child: SizedBox(
              width: 128,
              height: 128,
              child: Image.network(
                person.photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: scheme.surfaceContainerHighest,
                  child: const Icon(Icons.person, size: 64),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                InfoRow(label: 'Nombre', value: person.firstName),
                InfoRow(label: 'Apellido', value: person.lastName),
                InfoRow(
                  label: 'Fecha de nacimiento',
                  value: shortDate(person.birthDate),
                ),
                InfoRow(label: 'Edad', value: '${person.age} años'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onNext,
          icon: const Icon(Icons.refresh),
          label: const Text('Otra persona'),
        ),
      ],
    );
  }
}
