import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String category;
  final int bookedCount;
  final int favoritedCount;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    this.bookedCount = 0,
    this.favoritedCount = 0,
  });

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    String? category,
    int? bookedCount,
    int? favoritedCount,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      category: category ?? this.category,
      bookedCount: bookedCount ?? this.bookedCount,
      favoritedCount: favoritedCount ?? this.favoritedCount,
    );
  }

  static Map<DateTime, List<Event>> groupEventsByDate(List<Event> events) {
    final Map<DateTime, List<Event>> eventsByDate = {};
    
    for (final event in events) {
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (eventsByDate.containsKey(date)) {
        eventsByDate[date]!.add(event);
      } else {
        eventsByDate[date] = [event];
      }
    }
    
    return eventsByDate;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        date,
        location,
        category,
        bookedCount,
        favoritedCount,
      ];
}