import 'package:flutter/material.dart';
import 'package:flutter_event_app/core/constants/app_constants.dart';
import 'package:flutter_event_app/core/constants/colors.dart';
import 'package:flutter_event_app/domain/entities/event.dart';
import 'package:flutter_event_app/presentation/providers/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EventCard extends ConsumerWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventNotifierProvider);
    final isFavorite = state.favoriteEventIds.contains(event.id);
    final isBooked = state.bookedEventIds.contains(event.id);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isFavorite
              ? AppColors.favorited
              : isBooked
                  ? AppColors.booked
                  : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.push('/event/${event.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppConstants.eventImages[event.category] ?? '🎉',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${event.date.day}/${event.date.month}/${event.date.year} ${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.favorited : Colors.grey,
                    ),
                    onPressed: () {
                      ref.read(eventNotifierProvider.notifier).toggleFavorite(event.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        event.location,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.category, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        event.category,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCountBadge(
                    icon: Icons.favorite,
                    count: event.favoritedCount,
                    color: AppColors.favorited,
                  ),
                  _buildCountBadge(
                    icon: Icons.bookmark,
                    count: event.bookedCount,
                    color: AppColors.booked,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(eventNotifierProvider.notifier).bookEvent(event.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBooked ? AppColors.booked : AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isBooked ? 'Booked' : 'Book'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}