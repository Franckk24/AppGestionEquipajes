class Encomienda {
  final int? id;
  final String nombreConductor;
  final String telefono;
  final String numeroBuseta;
  final int maletas;
  final int valorEncomienda;
  final int valorGuardado;
  final String fecha;

  Encomienda({
    this.id,
    required this.nombreConductor,
    required this.telefono,
    required this.numeroBuseta,
    required this.maletas,
    required this.valorEncomienda,
    required this.valorGuardado,
    required this.fecha,
  });

  // Convertir a Map para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreConductor': nombreConductor,
      'telefono': telefono,
      'numeroBuseta': numeroBuseta,
      'maletas': maletas,
      'valorEncomienda': valorEncomienda,
      'valorGuardado': valorGuardado,
      'fecha': fecha,
    };
  }

  // Crear una Encomienda desde un Map
  factory Encomienda.fromMap(Map<String, dynamic> map) {
    return Encomienda(
      id: map['id'],
      nombreConductor: map['nombreConductor'],
      telefono: map['telefono'],
      numeroBuseta: map['numeroBuseta'],
      maletas: map['maletas'],
      valorEncomienda: map['valorEncomienda'],
      valorGuardado: map['valorGuardado'],
      fecha: map['fecha'],
    );
  }
}
