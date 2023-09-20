import 'package:skillify/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataSourceUtils {
  const DataSourceUtils._();

  static Future<void> authorizeUser(SupabaseClient client) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'User is not authenticated',
        statusCode: '401',
      );
    }
  }
}
