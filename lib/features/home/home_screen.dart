import 'package:flutter/material.dart';

import '../../core/feature.dart';
import '../../core/features.dart';
import '../../core/widgets/state_views.dart';
import 'toolbox_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caja de herramientas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ToolboxBanner(),
          const SizedBox(height: 20),
          if (features.isEmpty)
            const SizedBox(
              height: 240,
              child: MessageView(
                icon: Icons.handyman_outlined,
                message: 'Todavía no hay herramientas en la caja.',
              ),
            )
          else
            for (final feature in features) _FeatureTile(feature: feature),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature});

  final Feature feature;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Icon(feature.icon),
        ),
        title: Text(feature.title),
        subtitle: Text(feature.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: feature.builder),
        ),
      ),
    );
  }
}
