import 'package:flutter/material.dart';

import '../providers/user_directory_provider.dart';
import 'user_card_widget.dart';

/// A performant list widget that displays users with their post counts
class UserListWidget extends StatelessWidget {
  final List<UserWithPostCount> users;

  const UserListWidget({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserCardWidget(userWithPosts: users[index]);
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull to refresh or try again later',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
