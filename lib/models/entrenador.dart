class Entrenador {
  int? id;
  String nombre;
  int experiencia; // Años de experiencia
  String especialidad;

  Entrenador({
    this.id,
    required this.nombre,
    required this.experiencia,
    required this.especialidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'experiencia': experiencia,
      'especialidad': especialidad,
    };
  }

  static Entrenador fromMap(Map<String, dynamic> map) {
    return Entrenador(
      id: map['id'],
      nombre: map['nombre'],
      experiencia: map['experiencia'],
      especialidad: map['especialidad'],
    );
  }
}
