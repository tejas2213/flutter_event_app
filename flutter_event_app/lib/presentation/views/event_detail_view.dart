import 'package:flutter/material.dart';
import 'package:flutter_event_app/core/constants/app_constants.dart';
import 'package:flutter_event_app/core/constants/colors.dart';
import 'package:flutter_event_app/presentation/providers/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDetailView extends ConsumerWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventNotifierProvider);
    final event = state.events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final isFavorite = state.favoriteEventIds.contains(eventId);
    final isBooked = state.bookedEventIds.contains(eventId);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppConstants.eventImages[event.category] ?? '🎉',
                style: const TextStyle(fontSize: 64),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date & Time',
              value: '${_formatDate(event.date)} at ${_formatTime(event.date)}',
            ),
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Location',
              value: event.location,
            ),
            _buildDetailRow(
              icon: Icons.category,
              label: 'Category',
              value: event.category,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCountInfo(
                  icon: Icons.favorite,
                  count: event.favoritedCount,
                  label: 'Favorites',
                  color: AppColors.favorited,
                ),
                _buildCountInfo(
                  icon: Icons.bookmark,
                  count: event.bookedCount,
                  label: 'Bookings',
                  color: AppColors.booked,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(eventNotifierProvider.notifier).toggleFavorite(eventId);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.favorited : null,
                  ),
                  label: Text(isFavorite ? 'Favorited' : 'Favorite'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFavorite ? AppColors.favorited.withOpacity(0.1) : null,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(eventNotifierProvider.notifier).bookEvent(eventId);
                  },
                  icon: Icon(
                    isBooked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBooked ? AppColors.booked : null,
                  ),
                  label: Text(isBooked ? 'Booked' : 'Book Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBooked ? AppColors.booked.withOpacity(0.1) : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountInfo({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}