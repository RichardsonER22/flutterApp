import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/futbolista.dart';
import '../models/usuario.dart';
import '../models/equipo.dart';
import '../models/entrenador.dart';
import '../models/estadio.dart';
import '../models/arbitro.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() => _instance;

  // Obtener la base de datos (inicializar si no existe)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'futbolistas.db');
    return await openDatabase(
      path,
      version: 4, // Incrementar la versión si cambias la estructura
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Crear las tablas al inicializar la base de datos
  Future<void> _createDB(Database db, int version) async {
  print("Creando las tablas...");
  await db.execute('''
    CREATE TABLE futbolistas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      edad INTEGER NOT NULL,
      posicion TEXT NOT NULL,
      goles INTEGER DEFAULT 0
    )
  ''');
  print("Tabla futbolistas creada.");

  await db.execute('''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL
    )
  ''');
  print("Tabla usuarios creada.");

  await db.execute('''
    CREATE TABLE equipos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      ciudad TEXT,
      titulos INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE entrenadores (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      experiencia INTEGER,
      especialidad TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE estadios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      ubicacion TEXT,
      capacidad INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE arbitros(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      nacionalidad TEXT,
      experiencia INTEGER
    )
  ''');

  print("Tabla equipos creada.");
}


  // Actualizar la base de datos si hay cambios
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 4) { // Cambia 4 por la versión que hayas incrementado
    await db.execute('''
      CREATE TABLE equipos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        ciudad TEXT,
        titulos INTEGER
      )
    ''');
  }
}


  // Métodos CRUD para futbolistas
  Future<int> insertFutbolista(Futbolista futbolista) async {
    final db = await database;
    return await db.insert('futbolistas', futbolista.toMap());
  }

  Future<List<Futbolista>> getFutbolistas() async {
    final db = await database;
    final maps = await db.query('futbolistas');
    return maps.map((map) => Futbolista.fromMap(map)).toList();
  }

  Future<int> updateFutbolista(Futbolista futbolista) async {
    final db = await database;
    return await db.update(
      'futbolistas',
      futbolista.toMap(),
      where: 'id = ?',
      whereArgs: [futbolista.id],
    );
  }

  Future<int> deleteFutbolista(int id) async {
    final db = await database;
    return await db.delete(
      'futbolistas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos CRUD para equipos
  Future<int> insertEquipo(Equipo equipo) async {
    final db = await database;
    return await db.insert('equipos', equipo.toMap());
  }

  Future<List<Equipo>> getEquipos() async {
    final db = await database;
    final maps = await db.query('equipos');
    return maps.map((map) => Equipo.fromMap(map)).toList();
  }

  Future<int> updateEquipo(Equipo equipo) async {
    final db = await database;
    return await db.update(
      'equipos',
      equipo.toMap(),
      where: 'id = ?',
      whereArgs: [equipo.id],
    );
  }

  Future<int> deleteEquipo(int id) async {
    final db = await database;
    return await db.delete(
      'equipos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertEntrenador(Entrenador entrenador) async {
  final db = await database;
  return await db.insert('entrenadores', entrenador.toMap());
}

Future<List<Entrenador>> getEntrenadores() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('entrenadores');
  return List.generate(maps.length, (i) => Entrenador.fromMap(maps[i]));
}

Future<int> updateEntrenador(Entrenador entrenador) async {
  final db = await database;
  return await db.update(
    'entrenadores',
    entrenador.toMap(),
    where: 'id = ?',
    whereArgs: [entrenador.id],
  );
}

Future<int> deleteEntrenador(int id) async {
  final db = await database;
  return await db.delete(
    'entrenadores',
    where: 'id = ?',
    whereArgs: [id],
  );
}
Future<int> insertEstadio(Estadio estadio) async {
  final db = await database;
  return await db.insert('estadios', estadio.toMap());
}

Future<List<Estadio>> getEstadios() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('estadios');
  return List.generate(maps.length, (i) => Estadio.fromMap(maps[i]));
}

Future<int> updateEstadio(Estadio estadio) async {
  final db = await database;
  return await db.update(
    'estadios',
    estadio.toMap(),
    where: 'id = ?',
    whereArgs: [estadio.id],
  );
}

Future<int> deleteEstadio(int id) async {
  final db = await database;
  return await db.delete(
    'estadios',
    where: 'id = ?',
    whereArgs: [id],
  );
}
Future<List<Arbitro>> getArbitros() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('arbitros');
  return List.generate(maps.length, (i) => Arbitro.fromMap(maps[i]));
}

Future<int> insertArbitro(Arbitro arbitro) async {
  final db = await database;
  return await db.insert('arbitros', arbitro.toMap());
}

Future<int> updateArbitro(Arbitro arbitro) async {
  final db = await database;
  return await db.update(
    'arbitros',
    arbitro.toMap(),
    where: 'id = ?',
    whereArgs: [arbitro.id],
  );
}

Future<int> deleteArbitro(int id) async {
  final db = await database;
  return await db.delete(
    'arbitros',
    where: 'id = ?',
    whereArgs: [id],
  );
}



  // Métodos para usuarios (registro e inicio de sesión)
  Future<void> registerUser(Usuario usuario) async {
    final db = await database;
    await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  Future<bool> isEmailRegistered(String email) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  // Método para depuración
  Future<void> printTables() async {
    final db = await database;
    final result = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    print('Tablas en la base de datos: $result');
  }

  // Método para cerrar la base de datos
  Future<void> closeDB() async {
    final db = await database;
    await db.close();
  }
}
