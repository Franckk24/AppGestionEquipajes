import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/registro.dart';
import '../models/encomiendas.dart';

class DBHelper {
  static Database? _db;

  static const String dbName = 'equipaje.db';
  static const int dbVersion = 1;

  // Inicializar la base de datos
  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    _db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE registros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            tipoId TEXT,
            cedula TEXT,
            maletas INTEGER,
            ficha TEXT,
            precio INTEGER,
            fechaIngreso TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE encomiendas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreConductor TEXT,
            telefono TEXT,
            numeroBuseta TEXT,
            maletas INTEGER,
            valorEncomienda INTEGER,
            valorGuardado INTEGER,
            fecha TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  // ------------------------ REGISTROS NORMALES ------------------------
  static Future<int> insertarRegistro(Registro registro) async {
    final db = await getDatabase();
    return await db.insert('registros', registro.toMap());
  }

  static Future<List<Registro>> obtenerRegistros() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('registros');
    print('Registros desde BD: $maps');
    return maps.map((map) => Registro.fromMap(map)).toList();
  }

  // ------------------------ ENCOMIENDAS ------------------------
  static Future<int> insertarEncomienda(Encomienda encomienda) async {
    final db = await getDatabase();
    return await db.insert('encomiendas', encomienda.toMap());
  }

  static Future<List<Encomienda>> obtenerEncomiendas() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('encomiendas');
    return maps.map((map) => Encomienda.fromMap(map)).toList();
  }

  static Future<Map<String, int>> obtenerTotalesDesglosados() async {
    final registros = await obtenerRegistros();
    final encomiendas = await obtenerEncomiendas();

    int totalRegistros = 0;
    int totalEncomiendas = 0;
    int totalValorEncomienda = 0;
    final now = DateTime.now();

    for (var r in registros) {
      final fechaIngreso = DateTime.parse(r.fechaIngreso);
      final duracion = now.difference(fechaIngreso);
      final bloques = (duracion.inHours / 12)
          .ceil()
          .clamp(1, double.infinity)
          .toInt();
      totalRegistros += bloques * r.maletas * r.precio;
    }

    for (var e in encomiendas) {
      final fechaIngreso = DateTime.parse(e.fecha);
      final duracion = now.difference(fechaIngreso);
      final bloques = (duracion.inHours / 12).ceil().clamp(1, double.infinity).toInt();
      totalEncomiendas += bloques * e.valorGuardado * e.maletas;

      totalValorEncomienda += e.valorEncomienda;
    }

    return {
      'totalRegistros': totalRegistros,
      'totalEncomiendas': totalEncomiendas,
      'totalGeneral': totalRegistros + totalEncomiendas,
      'totalValorEncomienda': totalValorEncomienda,
    };
  }

  // (Opcional) eliminar registros, limpiar tablas, etc.
}
