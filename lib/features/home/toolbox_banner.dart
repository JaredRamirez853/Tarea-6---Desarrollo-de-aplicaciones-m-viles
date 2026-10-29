import 'package:flutter/material.dart';

/// Foto de la caja de herramientas. Si el archivo todavía no existe
/// se muestra un aviso visible en lugar de una imagen inventada.
class ToolboxBanner extends StatelessWidget {
  const ToolboxBanner({super.key});

  static const imagePath = 'assets/images/caja_herramientas.jpg';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const _MissingPhoto(path: imagePath),
        ),
      ),
    );
  }
}

class _MissingPhoto extends StatelessWidget {
  const _MissingPhoto({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.handyman, size: 64, color: scheme.primary),
            const SizedBox(height: 8),
            Text('Agrega tu foto en\n$path', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
