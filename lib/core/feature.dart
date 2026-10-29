import 'package:flutter/material.dart';

/// Describe una herramienta de la app. Cada módulo en `lib/features/`
/// declara la suya y la pantalla principal solo lee la lista.
class Feature {
  const Feature({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;
}
