class Registro {
  final int? id; // lo usará SQLite como clave primaria
  final String nombre;
  final String tipoId;
  final String cedula;
  final int maletas;
  final String ficha;
  final int precio;
  final String fechaIngreso;

  Registro({
    this.id,
    required this.nombre,
    required this.tipoId,
    required this.cedula,
    required this.maletas,
    required this.ficha,
    required this.precio,
    required this.fechaIngreso,
  });

  // Convertir un Registro a mapa para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'tipoId': tipoId,
      'cedula': cedula,
      'maletas': maletas,
      'ficha': ficha,
      'precio': precio,
      'fechaIngreso': fechaIngreso,
    };
  }

  // Crear un Registro desde un mapa (cuando leas de SQLite)
  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'],
      nombre: map['nombre'],
      tipoId: map['tipoId'],
      cedula: map['cedula'],
      maletas: map['maletas'],
      ficha: map['ficha'],
      precio: map['precio'],
      fechaIngreso: map['fechaIngreso'],
    );
  }
}
