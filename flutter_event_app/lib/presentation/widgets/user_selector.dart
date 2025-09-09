import 'package:flutter/material.dart';
import 'package:flutter_event_app/core/constants/app_constants.dart';
import 'package:flutter_event_app/presentation/providers/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSelector extends ConsumerWidget {
  const UserSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(eventNotifierProvider.select((state) => state.currentUserId));

    return DropdownButton<String>(
      value: currentUserId,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      onChanged: (String? newValue) {
        if (newValue != null) {
          ref.read(eventNotifierProvider.notifier).switchUser(newValue);
        }
      },
      items: AppConstants.users.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,),
        );
      }).toList(),
    );
  }
}