class Equipo {
  int? id;
  String nombre;
  String ciudad;
  int titulos;

  Equipo({
    this.id,
    required this.nombre,
    required this.ciudad,
    required this.titulos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'ciudad': ciudad,
      'titulos': titulos,
    };
  }

  static Equipo fromMap(Map<String, dynamic> map) {
    return Equipo(
      id: map['id'],
      nombre: map['nombre'],
      ciudad: map['ciudad'],
      titulos: map['titulos'],
    );
  }
}
