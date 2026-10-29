import 'package:flutter/material.dart';

import '../../core/feature.dart';
import '../../core/launcher.dart';
import 'about_data.dart';

final aboutFeature = Feature(
  title: 'Acerca de',
  subtitle: 'Contacto para posibles trabajos',
  icon: Icons.info_outline,
  builder: (_) => const AboutScreen(),
);

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: _ProfilePhoto()),
          const SizedBox(height: 16),
          Center(
            child: Text(
              AboutData.fullName,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Contacto para posibles trabajos',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 20),
          const _ContactTile(
            icon: Icons.badge_outlined,
            label: 'Matrícula',
            value: AboutData.studentId,
          ),
          _ContactTile(
            icon: Icons.email_outlined,
            label: 'Correo',
            value: AboutData.email,
            onTap: () => openUrl(context, 'mailto:${AboutData.email}'),
          ),
          _ContactTile(
            icon: Icons.phone_outlined,
            label: 'Teléfono',
            value: AboutData.phoneDisplay,
            onTap: () => openUrl(context, 'tel:${AboutData.phoneDial}'),
          ),
          _ContactTile(
            icon: Icons.chat_outlined,
            label: 'WhatsApp',
            value: AboutData.phoneDisplay,
            onTap: () =>
                openUrl(context, 'https://wa.me/${AboutData.whatsappNumber}'),
          ),
        ],
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipOval(
      child: SizedBox(
        width: 140,
        height: 140,
        child: Image.asset(
          AboutData.photoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => ColoredBox(
            color: scheme.primaryContainer,
            child: Center(
              child: Text(
                AboutData.initials,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
        trailing: onTap == null ? null : const Icon(Icons.open_in_new),
        onTap: onTap,
      ),
    );
  }
}
