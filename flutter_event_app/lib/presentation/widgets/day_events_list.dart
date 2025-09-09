import 'package:flutter/material.dart';
import 'package:flutter_event_app/presentation/providers/event_provider.dart';
import 'package:flutter_event_app/presentation/widgets/event_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DayEventsList extends ConsumerWidget {
  const DayEventsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventNotifierProvider);
    final selectedDay = state.selectedDay;

    if (selectedDay == null) {
      return const Center(child: Text('Select a date to view events'));
    }

    final eventsMap = state.searchQuery.isNotEmpty
        ? state.filteredEventsByDate
        : state.eventsByDate;

    final dayEvents =
        eventsMap[DateTime(
          selectedDay.year,
          selectedDay.month,
          selectedDay.day,
        )] ??
        [];

    if (dayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No events for ${state.currentUserId} on ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${state.currentUserId}\'s Events',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dayEvents.length,
            itemBuilder: (context, index) {
              final event = dayEvents[index];
              return EventCard(event: event);
            },
          ),
        ),
      ],
    );
  }
}
