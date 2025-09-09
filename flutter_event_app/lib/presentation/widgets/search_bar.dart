import 'package:flutter/material.dart';
import 'package:flutter_event_app/presentation/providers/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSearchBar extends ConsumerWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(eventNotifierProvider.select((state) => state.searchQuery));
    final notifier = ref.read(eventNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: TextEditingController(text: searchQuery),
        decoration: InputDecoration(
          hintText: 'Search events...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    notifier.searchEvents('');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          notifier.searchEvents(value);
        },
      ),
    );
  }
}