import 'package:blogging_app/screens/add_blog/views/add_blog_screen.dart';
import 'package:blogging_app/network/models/blog_list_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_config/app_config.dart';
import '../../add_blog/view_model/blog_provider.dart';
import '../../onboard/view_model/login_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  Future<void> _openAddBlog(BuildContext context) async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute<String>(
        builder: (_) => const AddBlogScreen(),
      ),
    );

    if (!context.mounted) return;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      await context.read<BlogProvider>().fetchBlogList(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your journal'),
        actions: [
          IconButton(
            onPressed: () => context.read<LoginProvider>().logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: Consumer<BlogProvider>(
        builder: (context, provider, child) {
          if (!provider.hasLoadedBlogs &&
              !provider.isLoadingBlogs &&
              provider.blogsError == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) provider.fetchBlogList();
            });
          }

          if (provider.isLoadingBlogs && !provider.hasLoadedBlogs) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.blogsError != null && !provider.hasLoadedBlogs) {
            return _StatusView(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load your blogs',
              actionLabel: 'Try again',
              onAction: () => provider.fetchBlogList(force: true),
            );
          }

          final blogs = provider.blogs;
          return RefreshIndicator(
            onRefresh: () => provider.fetchBlogList(force: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                _AddBlogBanner(onPressed: () => _openAddBlog(context)),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Latest stories',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      '${blogs.length} ${blogs.length == 1 ? 'story' : 'stories'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (blogs.isEmpty)
                  const _StatusView(
                    icon: Icons.auto_stories_outlined,
                    title: 'Your first story starts here',
                    message: 'Share something worth remembering.',
                  )
                else
                  ...blogs.map((blog) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _BlogCard(blog: blog),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddBlogBanner extends StatelessWidget {
  const _AddBlogBanner({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.primary,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.edit_note, size: 38, color: colors.onPrimary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write something new',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Turn an idea into your next story.',
                      style: TextStyle(
                        color: colors.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: colors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 8,
            child: Image.network(
              'http://192.168.1.2:8000${blog.coverImage}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: theme.colorScheme.secondaryContainer,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 36,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      child: Text(
                        blog.author.username.isEmpty
                            ? '?'
                            : blog.author.username[0].toUpperCase(),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        blog.author.username,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                    Text(
                      _formatDate(blog.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: Colors.grey.shade500),
            const SizedBox(height: 14),
            Text(title, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(message!, textAlign: TextAlign.center),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}