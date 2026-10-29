# Caja de herramientas

App Flutter con varias herramientas que consumen APIs públicas. Cada herramienta vive en su propia carpeta dentro de `lib/features/`.

## Herramientas

- [ ] Foto de la caja de herramientas (pantalla principal)
- [ ] Género por nombre (Genderize)
- [ ] Persona aleatoria (Random User)
- [ ] Universidades por país
- [ ] Clima en RD (Open-Meteo)
- [ ] Pokémon (PokeAPI)
- [ ] Noticias de un sitio WordPress
- [ ] Acerca de

## APIs

| Herramienta | API |
| --- | --- |
| Género | https://api.genderize.io/?name=irma |
| Persona aleatoria | https://randomuser.me/api/?results=1 |
| Universidades | https://adamix.net/proxy.php?country=Dominican+Republic |
| Clima | https://api.open-meteo.com/v1/forecast |
| Pokémon | https://pokeapi.co/api/v2/pokemon/pikachu |
| WordPress | https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3 |

## Estructura

```
lib/
  main.dart, app.dart
  core/            cliente HTTP, tema, widgets y utilidades compartidas
  features/
    home/          pantalla principal con la foto de la caja
    gender/        *_service.dart (modelo + API) y *_screen.dart (pantalla)
    random_user/
    universities/
    weather/
    pokemon/
    wordpress/
    about/
assets/
  images/          caja_herramientas.jpg y foto_perfil.jpg
  icon/            icon.png (ícono de la app)
```

## Ejecutar

```
flutter pub get
flutter run
```

## Autor

Jared Ramirez Sosa, matrícula 2025-1207.
