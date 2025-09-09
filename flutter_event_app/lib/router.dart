import 'package:flutter_event_app/presentation/views/calendar_view.dart';
import 'package:flutter_event_app/presentation/views/event_detail_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CalendarView(),
      ),
      GoRoute(
        path: '/event/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventDetailView(eventId: eventId);
        },
      ),
    ],
  );
}