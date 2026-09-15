import 'package:blogging_app/screens/add_blog/view_model/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddBlogScreen extends StatelessWidget {
  const AddBlogScreen({super.key});

  static const routeName = '/add_blog';

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<BlogCubit>();
    final title = cubit.state.title.trim();
    final content = cubit.state.content.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a title and some content first.')),
      );
      return;
    }
    if (cubit.state.selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a cover image for your story.')),
      );
      return;
    }

    try {
      final response = await cubit.addBlogData(
        title: title,
        content: content,
        imagePath: cubit.state.selectedImage!.path,
      );
      if (!context.mounted) return;
      cubit.clearData();
      if (context.mounted) Navigator.pop(context, response.message);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New story'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
        ),
      ),
      body: BlocBuilder<BlogCubit, BlogState>(
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share a thought',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Give your idea a home and let your readers in.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
              const SizedBox(height: 24),
              const _FieldLabel(label: 'Cover image'),
              const SizedBox(height: 8),
              _CoverPicker(
                cubit: context.read<BlogCubit>(),
                colors: Theme.of(context).colorScheme,
              ),
              const SizedBox(height: 24),
              const _FieldLabel(label: 'Title'),
              const SizedBox(height: 8),
              TextField(
                onChanged: context.read<BlogCubit>().setTitle,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Give your story a memorable title',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 20),
              const _FieldLabel(label: 'Your story'),
              const SizedBox(height: 8),
              TextField(
                onChanged: context.read<BlogCubit>().setContent,
                minLines: 7,
                maxLines: 10,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Write something worth remembering...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: state.isSubmitting
                      ? null
                      : () => _submit(context),
                  icon: state.isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.publish_rounded),
                  label: Text(
                    state.isSubmitting ? 'Publishing...' : 'Publish story',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        Text('  *', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ],
    );
  }
}

class _CoverPicker extends StatelessWidget {
  const _CoverPicker({required this.cubit, required this.colors});

  final BlogCubit cubit;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final image = cubit.state.selectedImage;
    return Material(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: cubit.pickImage,
        child: SizedBox(
          height: 190,
          width: double.infinity,
          child: image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 42, color: colors.primary),
                    const SizedBox(height: 10),
                    const Text('Choose a cover image', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('JPG or PNG', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(image, fit: BoxFit.cover),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: IconButton.filled(
                        onPressed: cubit.pickImage,
                        icon: const Icon(Icons.edit_rounded),
                        tooltip: 'Change image',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}