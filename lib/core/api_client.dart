import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// GET que devuelve el JSON decodificado o lanza [ApiException]
/// con un mensaje listo para mostrar al usuario.
Future<dynamic> getJson(Uri uri) async {
  final http.Response response;
  try {
    response = await http.get(uri).timeout(const Duration(seconds: 15));
  } on TimeoutException {
    throw const ApiException('La conexión tardó demasiado. Intenta de nuevo.');
  } catch (_) {
    throw const ApiException('No se pudo conectar. Revisa tu internet.');
  }

  switch (response.statusCode) {
    case 200:
      break;
    case 404:
      throw const ApiException('No se encontró lo que buscabas.');
    case 429:
      throw const ApiException(
          'Se alcanzó el límite de consultas de esta API. Prueba más tarde.');
    default:
      throw ApiException(
          'El servidor respondió con el código ${response.statusCode}.');
  }

  try {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } on FormatException {
    throw const ApiException('La respuesta no tiene el formato esperado.');
  }
}
