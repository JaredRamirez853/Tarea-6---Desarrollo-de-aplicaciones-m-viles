const _months = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

const _weekdays = [
  'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo',
];

String _two(int n) => n.toString().padLeft(2, '0');

/// 28/10/2026
String shortDate(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

/// miércoles 28 de octubre de 2026
String longDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]} ${d.day} de ${_months[d.month - 1]} de ${d.year}';
