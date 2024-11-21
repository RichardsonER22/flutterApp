class Estadio {
  int? id;
  String nombre;
  String ubicacion;
  int capacidad;

  Estadio({
    this.id,
    required this.nombre,
    required this.ubicacion,
    required this.capacidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'capacidad': capacidad,
    };
  }

  static Estadio fromMap(Map<String, dynamic> map) {
    return Estadio(
      id: map['id'],
      nombre: map['nombre'],
      ubicacion: map['ubicacion'],
      capacidad: map['capacidad'],
    );
  }
}
