import 'package:flutter/material.dart';

import '../../data/models/post_model.dart';
import '../../data/models/user_model.dart';
import 'loading_widget.dart';
import 'post_tile_widget.dart';

/// A widget that displays a list of posts with optimized performance.
class PostListWidget extends StatelessWidget {
  final List<Post> posts;
  final Map<int, User> userMap;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  final void Function(Post post)? onPostTap;

  const PostListWidget({
    super.key,
    required this.posts,
    required this.userMap,
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget(message: 'Loading posts...');
    }

    if (error != null) {
      return AppErrorWidget(
        message: error!,
        onRetry: onRetry,
      );
    }

    if (posts.isEmpty) {
      return const EmptyStateWidget(
        title: 'No posts found',
        subtitle: 'There are no posts to display at the moment.',
        icon: Icons.article_outlined,
      );
    }

    // Using ListView.builder for optimized performance with large lists
    return RefreshIndicator(
      onRefresh: () async {
        onRetry?.call();
      },
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        // Add some padding at the top and bottom
        padding: const EdgeInsets.symmetric(vertical: 12),
        // Performance optimizations
        itemCount: posts.length,
        // Use cacheExtent to pre-build items for smoother scrolling
        cacheExtent: 200,
        itemBuilder: (context, index) {
          final post = posts[index];
          final user = userMap[post.userId];

          return PostTileWidget(
            post: post,
            user: user,
            onTap: onPostTap != null ? () => onPostTap!(post) : null,
          );
        },
      ),
    );
  }
}
