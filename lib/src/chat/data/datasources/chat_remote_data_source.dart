import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/datasource_utils.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:skillify/src/chat/data/models/group_model.dart';
import 'package:skillify/src/chat/data/models/message_model.dart';
import 'package:skillify/src/chat/domain/entities/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatRemoteDataSource {
  const ChatRemoteDataSource();

  Future<void> sendMessage(Message message);

  Stream<List<MessageModel>> getMessages(String groupId);

  Stream<List<GroupModel>> getGroups();

  Future<void> joinGroup({required String groupId, required String userId});

  Future<void> leaveGroup({required String groupId, required String userId});

  Future<LocalUserModel> getUserById(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  final SupabaseClient _client;

  @override
  Stream<List<GroupModel>> getGroups() {
    try {
      DataSourceUtils.authorizeUser(_client);
      final groupStream = _client.from('groups').stream(primaryKey: ['id']).map(
        (event) => event
            .map(
              GroupModel.fromMap,
            )
            .toList(),
      );
      return groupStream;
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String groupId) {
    try {
      DataSourceUtils.authorizeUser(_client);
      final messageStream = _client
          .from('messages')
          .stream(primaryKey: ['id'])
          .order('timestamp')
          .eq('group_id', groupId)
          .map(
            (event) => event
                .map(
                  MessageModel.fromMap,
                )
                .toList(),
          );
      return messageStream;
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);

      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<LocalUserModel> getUserById(String userId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final res = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single()
          .execute();
      return LocalUserModel.fromMap(res.data as DataMap);
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final data = {
        'userId': userId,
        'id': groupId,
      };
      final res = await http.put(
        Uri.parse('https://comparative-turquoise.cmd.outerbase.io/joinGroup'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) {
        print('joined group');
      }
      final response = await _client
          .from('users')
          .select('groupIds')
          .eq('id', userId)
          .execute();

      final userDocument = response.data as List<dynamic>;

      final existingGroups =
          userDocument.isNotEmpty ? userDocument[0]['groupIds'] : [];

      existingGroups.add(groupId);

      final updateResponse = await _client.from('users').upsert([
        {
          'id': userId,
          'groupIds': existingGroups,
        }
      ]).execute();
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final data = {
        'userId': userId,
        'id': groupId,
      };
      final res = await http.put(
        Uri.parse('https://comparative-turquoise.cmd.outerbase.io/leavegroups'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) {
        print('left group');
      }
      final response = await _client
          .from('users')
          .select('groupIds')
          .eq('id', userId)
          .execute();

      final userDocument = response.data as List<dynamic>;

      final existingGroups =
          userDocument.isNotEmpty ? userDocument[0]['groupIds'] : [];

      existingGroups.remove(groupId);

      final updateResponse = await _client.from('users').upsert([
        {
          'id': userId,
          'groupIds': existingGroups,
        }
      ]).execute();
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> sendMessage(Message message) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final messageData = {
        'group_id': message.groupId,
        'sender_id': _client.auth.currentUser!.id,
        'message': message.message,
      };
      final res = await http.post(
        Uri.parse('https://comparative-turquoise.cmd.outerbase.io/messages'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(messageData),
      );

      if (res.statusCode == 200) {
        print('message sent');
      } else {
        print(
          'Failed sending messages. Status code: ${res.statusCode}, '
          'Response body: ${res.body}',
        );
      }
      final userName = await _client
          .from('users')
          .select('name')
          .eq('id', _client.auth.currentUser!.id);

      await _client.from('groups').update({
        'lastMessage': message.message,
        'lastMessageSenderName': userName,
        'lastMessageTimeStamp': message.timestamp.toIso8601String(),
      }).eq('id', message.groupId);
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
