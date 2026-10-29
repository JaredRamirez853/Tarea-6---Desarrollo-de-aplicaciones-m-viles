import 'package:flutter/material.dart';

import '../api_client.dart';
import 'state_views.dart';

/// Resuelve los cuatro estados de una consulta: sin buscar, cargando,
/// error y datos. Así cada pantalla solo dibuja el caso con datos.
class FutureView<T> extends StatelessWidget {
  const FutureView({
    super.key,
    required this.future,
    required this.builder,
    this.emptyMessage = 'Sin datos.',
    this.onRetry,
  });

  final Future<T>? future;
  final Widget Function(BuildContext context, T data) builder;
  final String emptyMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final current = future;
    if (current == null) {
      return MessageView(icon: Icons.search, message: emptyMessage);
    }
    return FutureBuilder<T>(
      future: current,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingView();
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          return MessageView(
            icon: Icons.cloud_off,
            message: error is ApiException
                ? error.message
                : 'Algo salió mal al leer la respuesta.',
            onRetry: onRetry,
          );
        }
        return builder(context, snapshot.requireData);
      },
    );
  }
}
