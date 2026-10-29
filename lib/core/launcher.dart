import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre enlaces web, `mailto:` y `tel:` fuera de la app.
Future<void> openUrl(BuildContext context, String url) async {
  var opened = false;
  try {
    opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (_) {
    opened = false;
  }
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace.')),
    );
  }
}
