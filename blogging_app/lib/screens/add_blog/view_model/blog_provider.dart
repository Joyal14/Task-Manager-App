import 'dart:io';
import 'package:blogging_app/network/models/blod_add_response.dart';
import 'package:blogging_app/network/models/blog_list_response.dart';
import 'package:blogging_app/network/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class BlogState {
  const BlogState({
    this.selectedImage,
    this.title = '',
    this.content = '',
    this.blogs = const [],
    this.isLoadingBlogs = false,
    this.hasLoadedBlogs = false,
    this.isSubmitting = false,
    this.blogsError,
  });

  final File? selectedImage;
  final String title;
  final String content;
  final List<Blog> blogs;
  final bool isLoadingBlogs;
  final bool hasLoadedBlogs;
  final bool isSubmitting;
  final String? blogsError;

  BlogState copyWith({
    File? selectedImage,
    bool clearSelectedImage = false,
    String? title,
    String? content,
    List<Blog>? blogs,
    bool? isLoadingBlogs,
    bool? hasLoadedBlogs,
    bool? isSubmitting,
    String? blogsError,
    bool clearBlogsError = false,
  }) {
    return BlogState(
      selectedImage: clearSelectedImage
          ? null
          : selectedImage ?? this.selectedImage,
      title: title ?? this.title,
      content: content ?? this.content,
      blogs: blogs ?? this.blogs,
      isLoadingBlogs: isLoadingBlogs ?? this.isLoadingBlogs,
      hasLoadedBlogs: hasLoadedBlogs ?? this.hasLoadedBlogs,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      blogsError: clearBlogsError ? null : blogsError ?? this.blogsError,
    );
  }
}

class BlogCubit extends Cubit<BlogState> {
  final ApiService apiService;
  final ImagePicker _imagePicker = ImagePicker();

  BlogCubit(this.apiService) : super(const BlogState());

  void setTitle(String value) => emit(state.copyWith(title: value));

  void setContent(String value) => emit(state.copyWith(content: value));

  Future<void> pickImage() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 70,
    );

    if (pickedImage == null) {
      return;
    }

    emit(state.copyWith(selectedImage: File(pickedImage.path)));
  }

  Future<BlogAddResponseData> addBlogData({
    required String title,
    required String content,
    required String imagePath,
  }) async {
    if (state.selectedImage == null) {
      throw Exception('No image selected');
    }

    emit(state.copyWith(isSubmitting: true));
    try {
      return await apiService.addBlog(
        title: title,
        content: content,
        imagePath: imagePath,
      );
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  void clearData() {
    emit(state.copyWith(
      title: '',
      content: '',
      clearSelectedImage: true,
    ));
  }

  Future<void> fetchBlogList({bool force = false}) async {
    if (state.isLoadingBlogs || (state.hasLoadedBlogs && !force)) return;

    emit(state.copyWith(
      isLoadingBlogs: true,
      clearBlogsError: true,
    ));

    try {
      final response = await apiService.getBlogList();
      emit(state.copyWith(
        blogs: List.unmodifiable(response.blogs),
        hasLoadedBlogs: true,
      ));
    } catch (error) {
      emit(state.copyWith(blogsError: error.toString()));
    } finally {
      emit(state.copyWith(isLoadingBlogs: false));
    }
  }
}