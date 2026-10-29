import '../../core/api_client.dart';

class PokemonInfo {
  const PokemonInfo({
    required this.name,
    required this.imageUrl,
    required this.baseExperience,
    required this.abilities,
    required this.cryUrl,
  });

  final String name;
  final String? imageUrl;
  final int? baseExperience;
  final List<String> abilities;
  final String? cryUrl;

  factory PokemonInfo.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final other = sprites['other'] as Map<String, dynamic>?;
    final artwork = other?['official-artwork'] as Map<String, dynamic>?;
    final cries = json['cries'] as Map<String, dynamic>?;

    return PokemonInfo(
      name: json['name'] as String,
      imageUrl:
          artwork?['front_default'] as String? ?? sprites['front_default'] as String?,
      baseExperience: json['base_experience'] as int?,
      abilities: (json['abilities'] as List)
          .map<String>((a) =>
              ((a as Map<String, dynamic>)['ability'] as Map<String, dynamic>)['name']
                  as String)
          .map((name) => name.replaceAll('-', ' '))
          .toList(),
      cryUrl: cries?['latest'] as String?,
    );
  }
}

Future<PokemonInfo> fetchPokemon(String name) async {
  final slug = name.trim().toLowerCase().replaceAll(' ', '-');
  final json = await getJson(Uri.https('pokeapi.co', '/api/v2/pokemon/$slug'));
  return PokemonInfo.fromJson(json as Map<String, dynamic>);
}
