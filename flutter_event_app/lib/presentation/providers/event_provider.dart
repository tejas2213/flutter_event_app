import 'package:flutter_event_app/data/datasources/local/database_helper.dart';
import 'package:flutter_event_app/data/datasources/local/local_data_source.dart';
import 'package:flutter_event_app/data/repositories/event_repository_impl.dart';
import 'package:flutter_event_app/domain/repositories/event_repository.dart';
import 'package:flutter_event_app/presentation/providers/event_notifier.dart';
import 'package:flutter_event_app/presentation/providers/event_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSourceImpl(databaseHelper: ref.read(databaseHelperProvider));
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(localDataSource: ref.read(localDataSourceProvider));
});

final eventNotifierProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier(eventRepository: ref.read(eventRepositoryProvider));
});