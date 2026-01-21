import 'package:flutter/material.dart';

import '../providers/user_directory_provider.dart';

class UserCardWidget extends StatelessWidget {
  final UserWithPostCount userWithPosts;

  const UserCardWidget({super.key, required this.userWithPosts});

  @override
  Widget build(BuildContext context) {
    final user = userWithPosts.user;
    final postCount = userWithPosts.postCount;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _UserAvatar(name: user.name, colorScheme: colorScheme),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email.toLowerCase(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _PostCountChip(
                    postCount: postCount,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  user.address.city,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String name;
  final ColorScheme colorScheme;

  const _UserAvatar({required this.name, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    return '?';
  }
}

class _PostCountChip extends StatelessWidget {
  final int postCount;
  final ColorScheme colorScheme;

  const _PostCountChip({required this.postCount, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article_outlined,
            size: 14,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            '$postCount ${postCount == 1 ? 'post' : 'posts'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
