import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skillify/core/errors/exceptions.dart';
import 'package:skillify/core/utils/datasource_utils.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LeaderboardRemoteDataSource {
  const LeaderboardRemoteDataSource();

  Future<List<LocalUserModel>> getTopLearners();
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  const LeaderboardRemoteDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  final SupabaseClient _client;

  @override
  Future<List<LocalUserModel>> getTopLearners() async {
    try {
      await DataSourceUtils.authorizeUser(_client);
      final res = await http.get(
        Uri.parse('https://comparative-turquoise.cmd.outerbase.io/toplearners'),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['response']['items'] as List<dynamic>;
        return data.map((e) => LocalUserModel.fromMap(e as DataMap)).toList();
      } else {
        throw ServerException(
          message: 'Unexpected status code ${res.statusCode}',
          statusCode: res.statusCode.toString(),
        );
      }
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
