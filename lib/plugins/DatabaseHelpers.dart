import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  
  // Factory constructor to return the same instance
  factory DatabaseHelper() => _instance;
  
  // Internal constructor
  DatabaseHelper._internal();
  
  // Database reference
  static Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'pharmacy.db');
    
    print('Database path: $path');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Database creation
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE buy_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER,
        medicine_id INTEGER,
        quantity INTEGER,
        per_price TEXT,
        full_price TEXT,
        transaction_date TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        parent_id TEXT,
        is_disabled INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        code TEXT,
        expired_date TEXT,
        category_id INTEGER,
        type TEXT,
        unit TEXT,
        price TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        phone_number TEXT,
        buy_date TEXT,
        status TEXT,
        paid_date TEXT,
        is_paid INTEGER,
        description TEXT,
        medicine_list TEXT,
        amount TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        parent_id INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE units (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        parent_id INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        username TEXT,
        email TEXT NOT NULL,
        password TEXT,
        owner INTEGER NOT NULL DEFAULT 0,
        is_admin INTEGER NOT NULL DEFAULT 0,
        is_disabled INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await _initializeDefaultData(db);
  }

  // Initialize default data
  Future<void> _initializeDefaultData(Database db) async {
    // Insert default admin user
    await db.insert('users', {
      'id': '22ad2d42-9edb-4388-9b37-738168c56e02',
      'name': 'Admin',
      'username': 'admin',
      'email': 'admin@admin.com',
      'password': '123',
      'owner': 1,
      'is_admin': 1,
      'is_disabled': 0
    });

    // Insert initial medicine types
    await db.insert('types', {'id': 1, 'name': 'ទឹក', 'parent_id': null});
    await db.insert('types', {'id': 2, 'name': 'ម្សៅ', 'parent_id': null});
    await db.insert('types', {'id': 3, 'name': 'គ្រប់', 'parent_id': null});
    await db.insert('types', {'id': 4, 'name': 'សេរ៉ូម', 'parent_id': null});

    // Insert initial units
    await db.insert('units', {'id': 1, 'name': 'ដប', 'parent_id': null});
    await db.insert('units', {'id': 2, 'name': 'បន្ទះ', 'parent_id': null});
    await db.insert('units', {'id': 3, 'name': 'អំពូល', 'parent_id': null});
    await db.insert('units', {'id': 4, 'name': 'កញ្ជប់', 'parent_id': null});

    // Insert initial categories
    await db.insert('categories', {'id': 1, 'name': 'ក្អក', 'parent_id': null});
    await db.insert('categories', {'id': 2, 'name': 'គ្រុនផ្តាសាយ', 'parent_id': null});
    await db.insert('categories', {'id': 3, 'name': 'ឈឺក្បាល់', 'parent_id': null});
    await db.insert('categories', {'id': 4, 'name': 'រាក', 'parent_id': null});
    await db.insert('categories', {'id': 5, 'name': 'ចុកចាប់', 'parent_id': null});
    await db.insert('categories', {'id': 6, 'name': 'គ្រុន', 'parent_id': null});
    await db.insert('categories', {'id': 7, 'name': 'ក្តៅ', 'parent_id': null});
  }

  // Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}