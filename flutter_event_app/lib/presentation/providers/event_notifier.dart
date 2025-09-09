import 'package:flutter_event_app/domain/entities/event.dart';
import 'package:flutter_event_app/domain/repositories/event_repository.dart';
import 'package:flutter_event_app/presentation/providers/event_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventNotifier extends StateNotifier<EventState> {
  final EventRepository eventRepository;

  EventNotifier({required this.eventRepository}) : super(EventState.initial()) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    state = state.copyWith(isLoading: true);
    try {
      final events = await eventRepository.getEvents(state.currentUserId);
      final favorites = await eventRepository.getUserFavorites(state.currentUserId);
      final bookings = await eventRepository.getUserBookings(state.currentUserId);
      final eventsByDate = Event.groupEventsByDate(events);
      
      state = state.copyWith(
        events: events,
        filteredEvents: events,
        eventsByDate: eventsByDate,
        filteredEventsByDate: eventsByDate,
        favoriteEventIds: favorites,
        bookedEventIds: bookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void switchUser(String userId) async {
    state = state.copyWith(currentUserId: userId, isLoading: true);
    await loadUserData();
  }

  // void searchEvents(String query) {
  //   final filtered = state.events.where((event) {
  //     return event.title.toLowerCase().contains(query.toLowerCase()) ||
  //         event.description.toLowerCase().contains(query.toLowerCase()) ||
  //         event.category.toLowerCase().contains(query.toLowerCase());
  //   }).toList();

  //   state = state.copyWith(searchQuery: query, filteredEvents: filtered);
  // }

  void searchEvents(String query) {
  final filtered = state.events.where((event) {
    return event.title.toLowerCase().contains(query.toLowerCase()) ||
        event.description.toLowerCase().contains(query.toLowerCase()) ||
        event.category.toLowerCase().contains(query.toLowerCase());
  }).toList();

  final filteredByDate = Event.groupEventsByDate(filtered);

  state = state.copyWith(
    searchQuery: query, 
    filteredEvents: filtered,
    filteredEventsByDate: filteredByDate, 
  );
}

  void toggleFavorite(String eventId) async {
    final isCurrentlyFavorite = state.favoriteEventIds.contains(eventId);
    List<String> newFavorites;

    if (isCurrentlyFavorite) {
      newFavorites = state.favoriteEventIds.where((id) => id != eventId).toList();
      await eventRepository.toggleUserFavorite(state.currentUserId, eventId, false);
    } else {
      newFavorites = [...state.favoriteEventIds, eventId];
      await eventRepository.toggleUserFavorite(state.currentUserId, eventId, true);
    }

    // Update event favorited count
    final event = state.events.firstWhere((e) => e.id == eventId);
    final newFavoritedCount = isCurrentlyFavorite ? event.favoritedCount - 1 : event.favoritedCount + 1;
    
    await eventRepository.updateEventCounts(
      eventId, 
      event.bookedCount, 
      newFavoritedCount,
    );

    final updatedEvents = state.events.map((e) {
      if (e.id == eventId) {
        return e.copyWith(favoritedCount: newFavoritedCount);
      }
      return e;
    }).toList();

    final eventsByDate = Event.groupEventsByDate(updatedEvents);
    final filteredEventsByDate = Event.groupEventsByDate(state.filteredEvents);

    state = state.copyWith(
      events: updatedEvents,
      filteredEvents: _filterEvents(updatedEvents, state.searchQuery),
      eventsByDate: eventsByDate,
      filteredEventsByDate: filteredEventsByDate,
      favoriteEventIds: newFavorites,
    );
  }

  void bookEvent(String eventId) async {
    final isCurrentlyBooked = state.bookedEventIds.contains(eventId);
    List<String> newBookings;

    if (isCurrentlyBooked) {
      newBookings = state.bookedEventIds.where((id) => id != eventId).toList();
      await eventRepository.toggleUserBooking(state.currentUserId, eventId, false);
    } else {
      newBookings = [...state.bookedEventIds, eventId];
      await eventRepository.toggleUserBooking(state.currentUserId, eventId, true);
    }

    // Update event booked count
    final event = state.events.firstWhere((e) => e.id == eventId);
    final newBookedCount = isCurrentlyBooked ? event.bookedCount - 1 : event.bookedCount + 1;
    
    await eventRepository.updateEventCounts(
      eventId, 
      newBookedCount, 
      event.favoritedCount,
    );

    final updatedEvents = state.events.map((e) {
      if (e.id == eventId) {
        return e.copyWith(bookedCount: newBookedCount);
      }
      return e;
    }).toList();

    final eventsByDate = Event.groupEventsByDate(updatedEvents);
    final filteredEventsByDate = Event.groupEventsByDate(state.filteredEvents);

    state = state.copyWith(
      events: updatedEvents,
      filteredEvents: _filterEvents(updatedEvents, state.searchQuery),
      eventsByDate: eventsByDate,
      filteredEventsByDate: filteredEventsByDate,
      bookedEventIds: newBookings,
    );
  }

  List<Event> _filterEvents(List<Event> events, String query) {
    if (query.isEmpty) return events;
    
    return events.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()) ||
          event.description.toLowerCase().contains(query.toLowerCase()) ||
          event.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void updateCalendarFocus(DateTime focusedDay) {
    state = state.copyWith(focusedDay: focusedDay);
  }

  void selectDay(DateTime selectedDay) {
    state = state.copyWith(selectedDay: selectedDay);
  }

  void goToToday() {
    final now = DateTime.now();
    state = state.copyWith(
      focusedDay: now,
      selectedDay: now,
    );
  }
}