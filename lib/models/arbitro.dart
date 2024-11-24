class Arbitro {
  int? id;
  String nombre;
  String nacionalidad;
  int experiencia; // Años de experiencia

  Arbitro({
    this.id,
    required this.nombre,
    required this.nacionalidad,
    required this.experiencia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'nacionalidad': nacionalidad,
      'experiencia': experiencia,
    };
  }

  static Arbitro fromMap(Map<String, dynamic> map) {
    return Arbitro(
      id: map['id'],
      nombre: map['nombre'],
      nacionalidad: map['nacionalidad'],
      experiencia: map['experiencia'],
    );
  }
}
