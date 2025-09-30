import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:signalr_chat/Models/chat_content.dart';
import 'package:signalr_chat/Models/chat_partner_dto.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'package:signalr_chat/Storage/user_storage.dart';


class MessagesNotifier extends StateNotifier<List<Chatcontent>> {
  MessagesNotifier() : super([]);

  void setMessages(List<Chatcontent> msgs) {
    state = msgs;
  }

  void addMessage(Chatcontent msg) {
    state = [msg, ...state];
  }


  Future loadMessages(String roomId) async {
    final userStorage = UserStorage();
    final apiService = ApiService();

    try {
      final token = await userStorage.getToken();
      if (token == null) {
        // TODO: Át kell adni UI-nak valami hibaüzenetet
        return;
      }

      final resp = await apiService.getChatContents(roomId);
      if (resp != null && resp.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(resp.body);
        final msgs = jsonList.map((e) => Chatcontent.fromJson(e)).toList();
        state = [...msgs];
      }
    } catch (e) {
      debugPrint("hiba: $e");
    }
  }
 
  
  void clear() {
    state = [];
  }  
}


class ChatPartnerNotifier extends StateNotifier<ChatPartnerDto?> {
  ChatPartnerNotifier() : super(null);

  void setChatPartner(ChatPartnerDto user) {
    state = user;
  }

  void clear() {
    state = null;
  }  

}

final messagesProvider =
    StateNotifierProvider<MessagesNotifier, List<Chatcontent>>(
        (ref) => MessagesNotifier());

final chatPartnerProvider =
    StateNotifierProvider<ChatPartnerNotifier, ChatPartnerDto?>(
        (ref) => ChatPartnerNotifier());
