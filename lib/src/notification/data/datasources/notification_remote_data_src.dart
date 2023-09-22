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
  Future<void> clearAll() {
    try {
      DataSourceUtils.authorizeUser(_client);

      _client
          .from('notifications')
          .delete()
          .eq('userId', _client.auth.currentUser!.id);
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

      _client.from('notifications').upsert({
        'userId': _client.auth.currentUser!.id,
      });

      final res = _client
          .from('notifications')
          .select<PostgrestResponse>()
          .eq('userId', _client.auth.currentUser!.id)
          .order('sentAT')
          .asStream()
          .map((event) => event.data as List<dynamic>)
          .map(
            (notifications) => notifications
                .map(
                  (notification) => NotificationModel.fromMap(
                    notification as Map<String, dynamic>,
                  ),
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
      return Stream.error(
        ServerException(message: e.toString(), statusCode: '505'),
      );
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await DataSourceUtils.authorizeUser(_client);

      await _client
          .from('notifications')
          .update({
            'seen': true,
          })
          .eq('id', notificationId)
          .eq('userId', _client.auth.currentUser!.id);

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
  Future<void> sendNotification(Notification notification) async {
    try {
      await DataSourceUtils.authorizeUser(_client);

      final res = await _client.from('users').select<PostgrestResponse>();

      final users = res.data as List<dynamic>;

      for (final user in users) {
        final notificationModel = (notification as NotificationModel)
            .copyWith(id: const Uuid().v4())
            .toMap();

        final insertRes =
            await _client.from('notifications').insert(notificationModel);
      }
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message, statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }
}
