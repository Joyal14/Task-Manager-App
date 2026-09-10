import 'package:blogging_app/screens/add_blog/views/add_blog_screen.dart';
import 'package:blogging_app/network/models/blog_list_response.dart';
import 'package:blogging_app/network/models/comment_list_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../add_blog/view_model/blog_provider.dart';
import '../../onboard/view_model/login_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  Future<void> _openAddBlog(BuildContext context) async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute<String>(builder: (_) => const AddBlogScreen()),
    );

    if (!context.mounted) return;
    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
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
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
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
                  ...blogs.map(
                    (blog) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _BlogCard(blog: blog),
                    ),
                  ),
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
              'http://192.168.1.3:8000${blog.coverImage}',
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => _BlogDetailsScreen(blog: blog),
                      ),
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('View story'),
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
                const SizedBox(height: 18),
                const Divider(height: 1),
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

class _BlogDetailsScreen extends StatelessWidget {
  const _BlogDetailsScreen({required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Story details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  'http://192.168.1.3:8000${blog.coverImage}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => ColoredBox(
                    color: theme.colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 42,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              blog.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    blog.author.username.isEmpty
                        ? '?'
                        : blog.author.username[0].toUpperCase(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    blog.author.username,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _formatDate(blog.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              blog.content,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 28),
            _CommentsPanel(blog: blog),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CommentsPanel extends StatefulWidget {
  const _CommentsPanel({required this.blog});

  final Blog blog;

  @override
  State<_CommentsPanel> createState() => _CommentsPanelState();
}

class _CommentsPanelState extends State<_CommentsPanel> {
  final _commentController = TextEditingController();
  final List<CommentListResponseData> _comments = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadComments();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    try {
      final comments = await context.read<LoginProvider>().getCommentList(
        blogId: widget.blog.id,
      );
      if (!mounted) return;
      setState(() {
        _comments
          ..clear()
          ..addAll(comments);
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Write a comment first.')));
      return;
    }

    final loginProvider = context.read<LoginProvider>();
    final username = loginProvider.signinResponse?.user.username ?? 'User';
    setState(() => _isSubmitting = true);

    try {
      final comment = await loginProvider.addComment(
        content: content,
        blogId: widget.blog.id,
      );
      if (!mounted) return;
      setState(() {
        _comments.insert(
          0,
          CommentListResponseData(
            id: comment.id,
            content: comment.content,
            blogId: comment.blogId,
            createdBy: CreatedBy(
              id: comment.createdBy,
              username: username,
              email: '',
              profileImage: '',
            ),
            createdAt: comment.createdAt,
            updatedAt: comment.updatedAt,
            v: comment.v,
          ),
        );
        _commentController.clear();
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loginProvider.errorMessage ?? 'Could not add your comment.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final username = context.select<LoginProvider, String>(
      (provider) => provider.signinResponse?.user.username ?? 'You',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.forum_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Comments',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (!_isLoading) ...[
              const SizedBox(width: 6),
              Text(
                '${_comments.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: LinearProgressIndicator(minHeight: 2),
          )
        else if (_comments.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              'No comments yet. Start the conversation.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: _comments
                  .map(
                    (comment) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CommentAvatar(user: comment.createdBy),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.createdBy.username,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(comment.content),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                username.isEmpty ? '?' : username[0].toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _commentController,
                minLines: 1,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Comment as $username',
                  isDense: true,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _isSubmitting ? null : _submitComment,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
              tooltip: 'Add comment',
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  const _CommentAvatar({required this.user});

  final CreatedBy user;

  @override
  Widget build(BuildContext context) {
    final username = user.username.trim();
    final imagePath = user.profileImage.trim();
    final imageUrl = imagePath.isEmpty
        ? null
        : imagePath.startsWith('http')
        ? imagePath
        : 'http://192.168.1.3:8000$imagePath';

    return CircleAvatar(
      radius: 16,
      child: imageUrl == null
          ? Text(username.isEmpty ? '?' : username[0].toUpperCase())
          : ClipOval(
              child: Image.network(
                imageUrl,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Text(username.isEmpty ? '?' : username[0].toUpperCase()),
              ),
            ),
    );
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
