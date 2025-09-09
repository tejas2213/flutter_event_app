import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'events_app.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {


    await db.execute('''
      CREATE TABLE events(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT NOT NULL,
        category TEXT NOT NULL,
        booked_count INTEGER DEFAULT 0,
        favorited_count INTEGER DEFAULT 0,
        user_id TEXT NOT NULL
      )
    ''');

    // User favorites table
    await db.execute('''
      CREATE TABLE user_favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        event_id TEXT NOT NULL,
        UNIQUE(user_id, event_id)
      )
    ''');

    // User bookings table
    await db.execute('''
      CREATE TABLE user_bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        event_id TEXT NOT NULL,
        UNIQUE(user_id, event_id)
      )
    ''');

    // Insert sample data for different users
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final now = DateTime.now();
    final users = ['User A', 'User B', 'User C'];
    
    // Different events for each user
    final eventsData = {
      'User A': [
        {
          'id': '1',
          'title': 'Tech Conference 2024',
          'description': 'Annual technology conference',
          'date': DateTime(now.year, now.month, now.day + 2, 9, 0).toIso8601String(),
          'location': 'Convention Center',
          'category': 'Conference',
          'booked_count': 150,
          'favorited_count': 200,
          'user_id': 'User A'
        },
        {
          'id': '2',
          'title': 'Rock Music Festival',
          'description': 'Weekend rock music festival',
          'date': DateTime(now.year, now.month, now.day + 5, 14, 0).toIso8601String(),
          'location': 'City Park',
          'category': 'Music',
          'booked_count': 500,
          'favorited_count': 750,
          'user_id': 'User A'
        },
      ],
      'User B': [
        {
          'id': '3',
          'title': 'Art Exhibition',
          'description': 'Modern art exhibition',
          'date': DateTime(now.year, now.month, now.day + 3, 10, 0).toIso8601String(),
          'location': 'Art Gallery',
          'category': 'Exhibition',
          'booked_count': 80,
          'favorited_count': 120,
          'user_id': 'User B'
        },
        {
          'id': '4',
          'title': 'Basketball Championship',
          'description': 'National basketball finals',
          'date': DateTime(now.year, now.month, now.day + 1, 19, 0).toIso8601String(),
          'location': 'Sports Arena',
          'category': 'Sports',
          'booked_count': 300,
          'favorited_count': 400,
          'user_id': 'User B'
        },
      ],
      'User C': [
        {
          'id': '5',
          'title': 'Coding Workshop',
          'description': 'Hands-on coding workshop',
          'date': DateTime(now.year, now.month, now.day + 4, 13, 0).toIso8601String(),
          'location': 'Tech Hub',
          'category': 'Workshop',
          'booked_count': 45,
          'favorited_count': 90,
          'user_id': 'User C'
        },
        {
          'id': '6',
          'title': 'Networking Meetup',
          'description': 'Professional networking event',
          'date': DateTime(now.year, now.month, now.day + 7, 18, 0).toIso8601String(),
          'location': 'Business Center',
          'category': 'Conference',
          'booked_count': 120,
          'favorited_count': 180,
          'user_id': 'User C'
        },
      ],
    };

    for (final user in users) {
      for (final event in eventsData[user]!) {
        await db.insert('events', event, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }
}