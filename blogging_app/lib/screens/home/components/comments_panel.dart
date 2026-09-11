import 'package:blogging_app/network/models/blog_list_response.dart';
import 'package:blogging_app/network/models/comment_list_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_config/app_config.dart';
import '../../onboard/view_model/login_provider.dart';

class CommentsPanel extends StatefulWidget {
  const CommentsPanel({required this.blog, super.key});

  final Blog blog;

  @override
  State<CommentsPanel> createState() => _CommentsPanelState();
}

class _CommentsPanelState extends State<CommentsPanel> {
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
      : _resolveImageUrl(imagePath);

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

  String _resolveImageUrl(String imagePath) {
    final apiUri = Uri.parse(AppConfig.shared.userBaseUrl);
    final serverUri = Uri(
      scheme: apiUri.scheme,
      host: apiUri.host,
      port: apiUri.hasPort ? apiUri.port : null,
    );
    return serverUri
        .resolve(imagePath.startsWith('/') ? imagePath.substring(1) : imagePath)
        .toString();
  }
}