import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_directory_provider.dart';
import '../widgets/posts_map_widget.dart';
import '../widgets/shimmer_loading_widget.dart';
import '../widgets/user_list_widget.dart';

class UserDirectoryScreen extends StatefulWidget {
  const UserDirectoryScreen({super.key});

  @override
  State<UserDirectoryScreen> createState() => _UserDirectoryScreenState();
}

class _UserDirectoryScreenState extends State<UserDirectoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserDirectoryProvider>().fetchData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people_outline), text: 'Users'),
            Tab(icon: Icon(Icons.map_outlined), text: 'Posts Map'),
          ],
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
        ),
      ),
      body: Consumer<UserDirectoryProvider>(
        builder: (context, provider, child) {
          if (provider.hasError) {
            return _ErrorView(
              message: provider.errorMessage!,
              onRetry: provider.retry,
            );
          }

          if (provider.isLoading) {
            return TabBarView(
              controller: _tabController,
              children: const [
                ShimmerLoadingWidget(),
                MapShimmerLoadingWidget(),
              ],
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: provider.fetchData,
                child: UserListWidget(users: provider.usersWithPostCounts),
              ),

              PostsMapWidget(locations: provider.locationPostCounts),
            ],
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
