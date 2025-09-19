import 'package:googlemap_list/Src/Model/location_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';




class LocationDatabase {
  static final LocationDatabase instance = LocationDatabase._init();
  static Database? _database;
  LocationDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("locations.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE locations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL
    )
    ''');
  }

  Future<int> create(LocationModel loc) async {
    final db = await instance.database;
    return await db.insert('locations', loc.toMap());
  }

  Future<List<LocationModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query('locations');
    return result.map((e) => LocationModel.fromMap(e)).toList();
  }

  Future<int> update(LocationModel loc) async {
    final db = await instance.database;
    return await db.update('locations', loc.toMap(),
        where: 'id = ?', whereArgs: [loc.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }
}
