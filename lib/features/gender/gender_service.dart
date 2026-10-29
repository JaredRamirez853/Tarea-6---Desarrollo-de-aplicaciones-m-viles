import '../../core/api_client.dart';

class GenderResult {
  const GenderResult({
    required this.name,
    required this.gender,
    required this.probability,
    required this.count,
  });

  final String name;
  final String? gender;
  final double probability;
  final int count;

  bool get isMale => gender == 'male';

  factory GenderResult.fromJson(Map<String, dynamic> json, String fallbackName) {
    return GenderResult(
      name: json['name'] as String? ?? fallbackName,
      gender: json['gender'] as String?,
      probability: (json['probability'] as num?)?.toDouble() ?? 0,
      count: json['count'] as int? ?? 0,
    );
  }
}

Future<GenderResult> fetchGender(String name) async {
  final json = await getJson(
    Uri.https('api.genderize.io', '/', {'name': name}),
  );
  return GenderResult.fromJson(json as Map<String, dynamic>, name);
}
