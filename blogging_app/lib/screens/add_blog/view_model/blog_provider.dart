import 'dart:io';
import 'package:blogging_app/network/models/blod_add_response.dart';
import 'package:blogging_app/network/models/blog_list_response.dart';
import 'package:blogging_app/network/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BlogProvider extends ChangeNotifier {
  final ApiService apiService;
  final ImagePicker _imagePicker = ImagePicker();
   String _title = '';
  String _content = '';

  BlogProvider(this.apiService);

  File? _selectedImage;
  List<Blog> _blogs = [];
  bool _isLoadingBlogs = false;
  bool _hasLoadedBlogs = false;
    bool _isSubmitting = false;
  String? _blogsError;

  File? get selectedImage => _selectedImage;
  List<Blog> get blogs => List.unmodifiable(_blogs);
  bool get isLoadingBlogs => _isLoadingBlogs;
  bool get hasLoadedBlogs => _hasLoadedBlogs;
    bool get isSubmitting => _isSubmitting;
  String? get blogsError => _blogsError;

    String get title => _title;
  String get content => _content;


 void setTitle(String value) {
    _title = value;
  }

  void setContent(String value) {
    _content = value;
  }

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

    _selectedImage = File(pickedImage.path);
    notifyListeners();
  }

  Future<BlogAddResponseData> addBlogData({
    required String title,
    required String content,
    required String imagePath,
  }) async {
    if (_selectedImage == null) {
      throw Exception('No image selected');
    }

    _isSubmitting = true;
    notifyListeners();
    try {
      return await apiService.addBlog(
        title: title,
        content: content,
        imagePath: imagePath,
      );
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> clearData() async {
    _title = '';
    _content = '';
    _selectedImage = null;
    notifyListeners();
  }
  Future<void> fetchBlogList({bool force = false}) async {
    if (_isLoadingBlogs || (_hasLoadedBlogs && !force)) return;

    _isLoadingBlogs = true;
    _blogsError = null;
    notifyListeners();

    try {
      final response = await apiService.getBlogList();
      _blogs = response.blogs;
      _hasLoadedBlogs = true;
    } catch (error) {
      _blogsError = error.toString();
    } finally {
      _isLoadingBlogs = false;
      notifyListeners();
    }
  }

}