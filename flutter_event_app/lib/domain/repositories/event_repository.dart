import 'package:flutter_event_app/domain/entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents(String userId);
  Future<List<String>> getUserFavorites(String userId);
  Future<void> toggleUserFavorite(String userId, String eventId, bool isFavorite);
  Future<List<String>> getUserBookings(String userId);
  Future<void> toggleUserBooking(String userId, String eventId, bool isBooked);
  Future<void> updateEventCounts(String eventId, int bookedCount, int favoritedCount);
}