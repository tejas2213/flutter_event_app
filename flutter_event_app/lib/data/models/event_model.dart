import 'package:equatable/equatable.dart';
import 'package:flutter_event_app/domain/entities/event.dart';

class EventModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String category;
  final int bookedCount;
  final int favoritedCount;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    this.bookedCount = 0,
    this.favoritedCount = 0,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
  return EventModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    date: DateTime.parse(json['date']),
    location: json['location'],
    category: json['category'],
    bookedCount: json['booked_count'] ?? 0,
    favoritedCount: json['favorited_count'] ?? 0,
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'location': location,
    'category': category,
    'booked_count': bookedCount,
    'favorited_count': favoritedCount,
  };
}

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    String? category,
    int? bookedCount,
    int? favoritedCount,
  }) {
    return EventModel(
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

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      date: date,
      location: location,
      category: category,
      bookedCount: bookedCount,
      favoritedCount: favoritedCount,
    );
  }

  static Map<DateTime, List<EventModel>> groupEventsByDate(List<EventModel> events) {
    final Map<DateTime, List<EventModel>> eventsByDate = {};
    
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