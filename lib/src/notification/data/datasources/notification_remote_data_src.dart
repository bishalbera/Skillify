import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/datasource_utils.dart';
import 'package:skillify/src/notification/data/models/notification_model.dart';
import 'package:skillify/src/notification/domain/entities/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class NotificationRemoteDataSrc {
  const NotificationRemoteDataSrc();

  Future<void> markAsRead(String notificationId);

  Future<void> clearAll();

  Future<void> clear(String notificationId);

  Future<void> sendNotification(Notification notification);

  Stream<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSrcImpl implements NotificationRemoteDataSrc {
  const NotificationRemoteDataSrcImpl({required SupabaseClient client})
      : _client = client;

  final SupabaseClient _client;

  @override
  Future<void> clear(String notificationId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      await _client.from('notifications').delete().eq('id', notificationId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await DataSourceUtils.authorizeUser(_client);

      await _client.from('notifications').delete();
      //.eq('userId', _client.auth.currentUser!.id);
      return Future.value();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Stream<List<NotificationModel>> getNotifications() {
    try {
      DataSourceUtils.authorizeUser(_client);

      // _client.from('notifications').upsert({
      //   'userId': _client.auth.currentUser!.id,
      // });

      final res = _client
          .from('notifications')
          .stream(primaryKey: ['id'])
          //.eq('userId', _client.auth.currentUser!.id)
          .order('sentAt')
          .execute()
          .map(
            (dataList) => dataList
                .map(
                  NotificationModel.fromMap,
                )
                .toList(),
          );

      return res;
    } on PostgrestException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Stream.error(e);
    } catch (e) {
      print(e);
      return Stream.error(
        ServerException(message: e.toString(), statusCode: '505'),
      );
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final data = {
        'id': notificationId,
      };
      final res = await http.put(
        Uri.parse('https://comparative-turquoise.cmd.outerbase.io/markasread'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) {
        print('marked as read');
      }
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> sendNotification(Notification notification) async {
    try {
      await DataSourceUtils.authorizeUser(_client);

      // add notification to every user's notification collection
      final response = await _client
          .from('users')
          .select('id')
          .eq('id', _client.auth.currentUser!.id)
          .execute();

      final users = response.data as List;

      for (final user in users) {
        final newNotificationRef = await _client
            .from('notifications')
            .insert(
              (notification as NotificationModel)
                  .copyWith(id: const Uuid().v4())
                  .toMap(),
            )
            .execute();
      }
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }
}
