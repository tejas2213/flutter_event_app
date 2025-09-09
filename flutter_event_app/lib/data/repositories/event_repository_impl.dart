import 'package:flutter_event_app/data/datasources/local/local_data_source.dart';
import 'package:flutter_event_app/domain/entities/event.dart';
import 'package:flutter_event_app/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final LocalDataSource localDataSource;

  EventRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Event>> getEvents(String userId) async {
    final events = await localDataSource.getEvents(userId);
    return events.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<String>> getUserFavorites(String userId) async {
    return await localDataSource.getUserFavorites(userId);
  }

  @override
  Future<void> toggleUserFavorite(String userId, String eventId, bool isFavorite) async {
    if (isFavorite) {
      await localDataSource.saveUserFavorite(userId, eventId);
    } else {
      await localDataSource.removeUserFavorite(userId, eventId);
    }
  }

  @override
  Future<List<String>> getUserBookings(String userId) async {
    return await localDataSource.getUserBookings(userId);
  }

  @override
  Future<void> toggleUserBooking(String userId, String eventId, bool isBooked) async {
    if (isBooked) {
      await localDataSource.saveUserBooking(userId, eventId);
    } else {
      await localDataSource.removeUserBooking(userId, eventId);
    }
  }

  @override
  Future<void> updateEventCounts(String eventId, int bookedCount, int favoritedCount) async {
    await localDataSource.updateEventCounts(eventId, bookedCount, favoritedCount);
  }
}