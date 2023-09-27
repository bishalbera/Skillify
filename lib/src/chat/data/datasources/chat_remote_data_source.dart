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

import 'package:uuid/uuid.dart';

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
  Stream<List<GroupModel>> getGroups() async* {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final response = await http.get(
        Uri.parse('https://comparative-turquoise.cmd.outerbase.io/groups'),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData.containsKey('response') &&
            responseData['response'] is Map<String, dynamic> &&
            responseData['response']['items'] is List) {
          final data = responseData['response']['items'] as List<dynamic>;

          final groups = data.map((item) {
            return GroupModel.fromMap(item as DataMap);
          }).toList();

          yield groups;
        } else {
          throw Exception('Invalid response data format');
        }
      } else {
        throw Exception('Failed to fetch groups: ${response.body}');
      }
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String groupId) async* {
    try {
      await DataSourceUtils.authorizeUser(_client);

      final url = Uri.parse(
        'https://comparative-turquoise.cmd.outerbase.io/getmessages?groupId=$groupId',
      );

      final res = await http.get(url);
      if (res.statusCode == 200) {
        final jsonResponse = json.decode(res.body) as DataMap;
        if (jsonResponse['success'] == true) {
          final items = jsonResponse['response']['items'] as List;
          final messages = items
              .map((data) => MessageModel.fromMap(data as DataMap))
              .toList();
          yield messages;
        }
      }
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
        'groupid': message.groupId,
        'id': const Uuid().v4(),
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
      }
      final userName = await _client
          .from('users')
          .select('name')
          .eq('id', _client.auth.currentUser!.id);
      await _client.from('groups').update({
        'lastMessage': message.message,
        'lastMessageSenderName': userName,
        'lastMessageTimestamp': message.timestamp,
      });
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
