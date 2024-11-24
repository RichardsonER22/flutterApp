class Partido {
  final int id;
  final String equipoLocal;
  final String equipoVisitante;
  final DateTime fecha;
  final String lugar;

  Partido({
    required this.id,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.fecha,
    required this.lugar,
  });
}
