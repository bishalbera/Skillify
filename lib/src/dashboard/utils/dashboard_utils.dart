import 'dart:async';

import 'package:skillify/core/services/injection_container.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardUtils {
  const DashboardUtils._();

  static Stream<LocalUserModel> get userDataStream => sl<SupabaseClient>()
      .from('users')
      .stream(primaryKey: ['id'])
      .eq('id', sl<SupabaseClient>().auth.currentUser!.id)
      .map((event) {
        final data = event.first;
        return LocalUserModel.fromMap(data);
      });
}
