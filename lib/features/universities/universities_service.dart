import '../../core/api_client.dart';

class University {
  const University({required this.name, this.domain, this.webPage});

  final String name;
  final String? domain;
  final String? webPage;

  factory University.fromJson(Map<String, dynamic> json) {
    final domains = (json['domains'] as List?)?.cast<String>() ?? const [];
    final pages = (json['web_pages'] as List?)?.cast<String>() ?? const [];
    return University(
      name: json['name'] as String? ?? 'Sin nombre',
      domain: domains.isEmpty ? null : domains.first,
      webPage: pages.isEmpty ? null : pages.first,
    );
  }
}

Future<List<University>> fetchUniversities(String country) async {
  final json = await getJson(
    Uri.https('adamix.net', '/proxy.php', {'country': country}),
  );
  if (json is! List) {
    throw const ApiException('La respuesta no tiene el formato esperado.');
  }
  return json
      .map((item) => University.fromJson(item as Map<String, dynamic>))
      .toList();
}
