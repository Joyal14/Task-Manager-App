import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../constants/api_constants.dart';
import '../../../network/models/chat_message_response.dart';
import '../../../network/service/dio_api_helper.dart';

class ChatUser {
  const ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.initial,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String email;
  final String initial;
  final bool isOnline;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String senderId;
  final String username;
  final String text;
  final DateTime createdAt;
}

class ChatProvider with ChangeNotifier {
  ChatProvider() {
    _availableUsers = const [
      ChatUser(
        id: 'all',
        name: 'All users',
        email: 'all@example.com',
        initial: 'A',
        isOnline: true,
      ),
    ];
  }

  late final List<ChatUser> _availableUsers;
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChatUser> get availableUsers => List.unmodifiable(_availableUsers);
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMessages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioApiHelper.userApi.get<dynamic>(
        ApiUrlConstants.messages,
      );

      final data = response.data;
      if (data is! List) {
        throw const FormatException('Invalid chat response format');
      }

      _messages
        ..clear()
        ..addAll(
          data.map((item) {
            final json = item as Map<String, dynamic>;
            final message = ChatMessageResponse.fromJson(json);
            return ChatMessage(
              id: message.id,
              senderId: message.sender,
              username: message.username,
              text: message.text,
              createdAt: message.createdAt,
            );
          }).toList(),
        );
    } on DioException catch (error) {
      _errorMessage = error.response?.data is Map
          ? (error.response?.data['message'] ?? 'Could not load messages.')
          : 'Could not load messages.';
    } on Object catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioApiHelper.userApi.post<dynamic>(
        ApiUrlConstants.messages,
        data: {'text': trimmed},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final model = ChatMessageResponse.fromJson(data);
        _messages.add(
          ChatMessage(
            id: model.id,
            senderId: model.sender,
            username: model.username,
            text: model.text,
            createdAt: model.createdAt,
          ),
        );
      }
    } on DioException catch (error) {
      _errorMessage = error.response?.data is Map
          ? (error.response?.data['message'] ?? 'Message could not be sent.')
          : 'Message could not be sent.';
    } on Object catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
