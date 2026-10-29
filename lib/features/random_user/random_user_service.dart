import '../../core/api_client.dart';

class RandomPerson {
  const RandomPerson({
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.birthDate,
    required this.age,
  });

  final String firstName;
  final String lastName;
  final String photoUrl;
  final DateTime birthDate;
  final int age;

  factory RandomPerson.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    final dob = json['dob'] as Map<String, dynamic>;
    final isoDate = dob['date'] as String;
    return RandomPerson(
      firstName: name['first'] as String,
      lastName: name['last'] as String,
      photoUrl: (json['picture'] as Map<String, dynamic>)['large'] as String,
      // Solo la parte de fecha, para que la zona horaria no mueva el día.
      birthDate: DateTime.parse(isoDate.substring(0, 10)),
      age: dob['age'] as int,
    );
  }
}

Future<RandomPerson> fetchRandomPerson() async {
  final json = await getJson(
    Uri.https('randomuser.me', '/api/', {'results': '1'}),
  );
  final results = (json as Map<String, dynamic>)['results'] as List;
  return RandomPerson.fromJson(results.first as Map<String, dynamic>);
}
