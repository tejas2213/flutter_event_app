import 'package:flutter_event_app/data/datasources/local/database_helper.dart';
import 'package:flutter_event_app/data/models/event_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<List<EventModel>> getEvents(String userId);
  Future<void> saveEvent(EventModel event);
  Future<List<String>> getUserFavorites(String userId);
  Future<void> saveUserFavorite(String userId, String eventId);
  Future<void> removeUserFavorite(String userId, String eventId);
  Future<List<String>> getUserBookings(String userId);
  Future<void> saveUserBooking(String userId, String eventId);
  Future<void> removeUserBooking(String userId, String eventId);
  Future<void> updateEventCounts(String eventId, int bookedCount, int favoritedCount);
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper databaseHelper;

  LocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<EventModel>> getEvents(String userId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return maps.map((map) => EventModel.fromJson(map)).toList();
  }

  @override
  Future<void> saveEvent(EventModel event) async {
    final db = await databaseHelper.database;
    await db.insert(
      'events',
      event.toJson()..['user_id'] = event.id.split('_').last, // Extract user from event ID
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<String>> getUserFavorites(String userId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
      columns: ['event_id'],
    );

    return maps.map((map) => map['event_id'] as String).toList();
  }

  @override
  Future<void> saveUserFavorite(String userId, String eventId) async {
    final db = await databaseHelper.database;
    await db.insert(
      'user_favorites',
      {'user_id': userId, 'event_id': eventId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<void> removeUserFavorite(String userId, String eventId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'user_favorites',
      where: 'user_id = ? AND event_id = ?',
      whereArgs: [userId, eventId],
    );
  }

  @override
  Future<List<String>> getUserBookings(String userId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
      columns: ['event_id'],
    );

    return maps.map((map) => map['event_id'] as String).toList();
  }

  @override
  Future<void> saveUserBooking(String userId, String eventId) async {
    final db = await databaseHelper.database;
    await db.insert(
      'user_bookings',
      {'user_id': userId, 'event_id': eventId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<void> removeUserBooking(String userId, String eventId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'user_bookings',
      where: 'user_id = ? AND event_id = ?',
      whereArgs: [userId, eventId],
    );
  }

  @override
  Future<void> updateEventCounts(String eventId, int bookedCount, int favoritedCount) async {
    final db = await databaseHelper.database;
    await db.update(
      'events',
      {
        'booked_count': bookedCount,
        'favorited_count': favoritedCount,
      },
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }
}