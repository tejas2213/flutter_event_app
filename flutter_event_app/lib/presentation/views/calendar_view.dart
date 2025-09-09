import 'package:flutter/material.dart';
import 'package:flutter_event_app/core/constants/colors.dart';
import 'package:flutter_event_app/presentation/providers/event_provider.dart';
import 'package:flutter_event_app/presentation/widgets/day_events_list.dart';
import 'package:flutter_event_app/presentation/widgets/event_calendar.dart';
import 'package:flutter_event_app/presentation/widgets/search_bar.dart';
import 'package:flutter_event_app/presentation/widgets/user_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventNotifierProvider);
    final notifier = ref.read(eventNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Calendar'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () => notifier.goToToday(),
            tooltip: 'Go to today',
          ),
          const UserSelector(),
        ],
      ),
      body: Column(
        children: [
          const CustomSearchBar(),
          if (state.isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (state.error != null)
            Expanded(
              child: Center(
                child: Text('Error: ${state.error}'),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  const EventCalendar(),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 2,
                    child: DayEventsList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}