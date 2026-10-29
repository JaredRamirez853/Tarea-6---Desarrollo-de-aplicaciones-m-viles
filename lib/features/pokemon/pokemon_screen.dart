import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../core/feature.dart';
import '../../core/text_utils.dart';
import '../../core/widgets/future_view.dart';
import '../../core/widgets/search_field.dart';
import 'pokemon_service.dart';

final pokemonFeature = Feature(
  title: 'Pokémon',
  subtitle: 'Foto, experiencia base, habilidades y sonido',
  icon: Icons.catching_pokemon,
  builder: (_) => const PokemonScreen(),
);

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _player = AudioPlayer();
  Future<PokemonInfo>? _future;
  String _name = '';

  void _search(String name) {
    _player.stop();
    setState(() {
      _name = name;
      _future = fetchPokemon(name);
    });
  }

  Future<void> _playCry(String url) async {
    try {
      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este dispositivo no pudo reproducir el sonido.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(
              label: 'Nombre del Pokémon',
              hint: 'Ej. pikachu',
              onSearch: _search,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureView<PokemonInfo>(
                future: _future,
                emptyMessage: 'Escribe el nombre de un Pokémon, por ejemplo pikachu.',
                onRetry: () => _search(_name),
                builder: (context, pokemon) =>
                    _PokemonCard(pokemon: pokemon, onPlay: _playCry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  const _PokemonCard({required this.pokemon, required this.onPlay});

  final PokemonInfo pokemon;
  final ValueChanged<String> onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = pokemon.imageUrl;
    final cry = pokemon.cryUrl;

    return ListView(
      children: [
        SizedBox(
          height: 220,
          child: image == null
              ? const Icon(Icons.catching_pokemon, size: 96)
              : Image.network(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 96),
                ),
        ),
        Center(
          child: Text(
            capitalize(pokemon.name),
            style: theme.textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Chip(
            avatar: const Icon(Icons.bolt, size: 18),
            label: Text('Experiencia base: ${pokemon.baseExperience ?? 'sin dato'}'),
          ),
        ),
        const SizedBox(height: 12),
        Text('Habilidades', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final ability in pokemon.abilities)
              Chip(label: Text(capitalize(ability))),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: cry == null ? null : () => onPlay(cry),
          icon: const Icon(Icons.volume_up),
          label: Text(cry == null ? 'Sin sonido disponible' : 'Escuchar sonido'),
        ),
      ],
    );
  }
}
