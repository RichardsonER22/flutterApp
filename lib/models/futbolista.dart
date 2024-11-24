class Futbolista {
  int? id;
  String nombre;
  int edad;
  String posicion;
  int goles;

  Futbolista({
    this.id,
    required this.nombre,
    required this.edad,
    required this.posicion,
    required this.goles,
  });

  // Convertir Futbolista a Map para insertar en la BD
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'posicion': posicion,
      'goles': goles,
    };
  }

  // Crear Futbolista a partir de un Map (lectura de BD)
  static Futbolista fromMap(Map<String, dynamic> map) {
    return Futbolista(
      id: map['id'],
      nombre: map['nombre'],
      edad: map['edad'],
      posicion: map['posicion'],
      goles: map['goles'],
    );
  }
}
