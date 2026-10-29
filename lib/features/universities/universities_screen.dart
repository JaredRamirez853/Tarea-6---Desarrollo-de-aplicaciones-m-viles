import 'package:flutter/material.dart';

import '../../core/feature.dart';
import '../../core/launcher.dart';
import '../../core/widgets/future_view.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/state_views.dart';
import 'universities_service.dart';

final universitiesFeature = Feature(
  title: 'Universidades por país',
  subtitle: 'Nombre, dominio y sitio web',
  icon: Icons.school,
  builder: (_) => const UniversitiesScreen(),
);

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  Future<List<University>>? _future;
  String _country = '';

  void _search(String country) {
    setState(() {
      _country = country;
      _future = fetchUniversities(country);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades por país')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(
              label: 'País (en inglés)',
              hint: 'Dominican Republic',
              onSearch: _search,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureView<List<University>>(
                future: _future,
                emptyMessage:
                    'Escribe un país en inglés, por ejemplo Dominican Republic.',
                onRetry: () => _search(_country),
                builder: (context, list) {
                  if (list.isEmpty) {
                    return MessageView(
                      icon: Icons.school_outlined,
                      message: 'No hay universidades registradas para "$_country".',
                    );
                  }
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        _UniversityCard(university: list[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UniversityCard extends StatelessWidget {
  const _UniversityCard({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final page = university.webPage;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(university.name, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Dominio: ${university.domain ?? 'Sin dato'}'),
            const SizedBox(height: 4),
            Text(
              'Sitio: ${page ?? 'Sin dato'}',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: page == null ? null : () => openUrl(context, page),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Abrir sitio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
