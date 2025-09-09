import 'package:equatable/equatable.dart';
import 'package:flutter_event_app/domain/entities/event.dart';

class EventState extends Equatable {
  final List<Event> events;
  final Map<DateTime, List<Event>> eventsByDate;
  final Map<DateTime, List<Event>> filteredEventsByDate;
  final List<Event> filteredEvents;
  final List<String> favoriteEventIds;
  final List<String> bookedEventIds;
  final String currentUserId;
  final String searchQuery;
  final bool isLoading;
  final String? error;
  final DateTime focusedDay; 
  final DateTime? selectedDay;

  const EventState({
    required this.events,
    required this.eventsByDate,
    required this.filteredEventsByDate,
    required this.filteredEvents,
    required this.favoriteEventIds,
    required this.bookedEventIds,
    required this.currentUserId,
    required this.searchQuery,
    required this.isLoading,
    required this.focusedDay,
    this.selectedDay,
    this.error,
  });

  factory EventState.initial() {
    final now = DateTime.now();
    return EventState(
      events: const [],
      eventsByDate: const {},
      filteredEventsByDate: {},
      filteredEvents: const [],
      favoriteEventIds: const [],
      bookedEventIds: const [],
      currentUserId: 'User A',
      searchQuery: '',
      isLoading: false,
      focusedDay: now,
      selectedDay: now,
    );
  }

  EventState copyWith({
    List<Event>? events,
    List<Event>? filteredEvents,
    Map<DateTime, List<Event>>? eventsByDate,
    Map<DateTime, List<Event>>? filteredEventsByDate,
    List<String>? favoriteEventIds,
    List<String>? bookedEventIds,
    String? currentUserId,
    String? searchQuery,
    bool? isLoading,
    DateTime? focusedDay,
    DateTime? selectedDay,
    String? error,
  }) {
    return EventState(
      events: events ?? this.events,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      eventsByDate: eventsByDate ?? this.eventsByDate,
      filteredEventsByDate: filteredEventsByDate ?? this.filteredEventsByDate,
      favoriteEventIds: favoriteEventIds ?? this.favoriteEventIds,
      bookedEventIds: bookedEventIds ?? this.bookedEventIds,
      currentUserId: currentUserId ?? this.currentUserId,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        events,
        filteredEvents,
        eventsByDate,
        favoriteEventIds,
        bookedEventIds,
        currentUserId,
        searchQuery,
        isLoading,
        focusedDay,
        selectedDay,
        error,
      ];
}