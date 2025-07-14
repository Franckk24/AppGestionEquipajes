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

  // (Opcional) eliminar registros, limpiar tablas, etc.
}
