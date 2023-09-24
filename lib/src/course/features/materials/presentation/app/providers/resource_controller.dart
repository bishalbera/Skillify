import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillify/src/course/features/materials/domain/entities/resource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResourceController extends ChangeNotifier {
  ResourceController({
    required SupabaseStorageClient dbClient,
    required SharedPreferences prefs,
  })  : _dbClient = dbClient,
        _prefs = prefs;

  final SupabaseStorageClient _dbClient;

  final SharedPreferences _prefs;

  Resource? _resource;

  bool _loading = false;
  bool _downloading = false;

  double _percentage = 0;

  double get percentage => _percentage;

  bool get loading => _loading;
  bool get downloading => _downloading;

  Resource? get resource => _resource;

  String get _pathKey => 'material_file_path${_resource!.id}';

  void init(Resource resource) {
    if (_resource == resource) return;
    _resource = resource;
  }

  Future<File> _getFileFromCache() async {
    final cachedFilePath = _prefs.getString(_pathKey);
    return File(cachedFilePath!);
  }

  bool get fileExists {
    final cachedFilePath = _prefs.getString(_pathKey);
    if (cachedFilePath == null) return false;
    final file = File(cachedFilePath);
    final fileExists = file.existsSync();
    if (!fileExists) _prefs.remove(_pathKey);
    return fileExists;
  }

  Future<File?> downloadAndSaveFile() async {
    _loading = true;
    _downloading = true;
    notifyListeners();
    final cacheDir = await getTemporaryDirectory();
    final file = File(
      '${cacheDir.path}/'
      '${_resource!.id}.${_resource!.fileExtension}',
    );
    if (file.existsSync()) return file;
    try {
      await _dbClient
          .from('courses')
          .download(
            'courses/${_resource?.courseId}/materials/${_resource!.id}/material',
          )
          .then(
        (value) async {
          final fileSize = value.lengthInBytes;
          const chunkSize = 1024 * 1024;
          var offset = 0;
          var downloadedSize = 0;
          final sink = file.openWrite();
          while (offset < fileSize) {
            final end = min(offset + chunkSize, fileSize);
            final data = value.getRange(offset, end);
            sink.add(data.toList());
            downloadedSize += data.length;
            _percentage = downloadedSize / fileSize;
            notifyListeners();
            offset += chunkSize;
          }
          await sink.close();
        },
      );

      var successful = false;
      if (file.existsSync()) {
        _downloading = false;
        await _prefs.setString(_pathKey, file.path);
        successful = true;
      }
      return successful ? file : null;
    } catch (e) {
      print(e);
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFile() async {
    if (fileExists) {
      final file = await _getFileFromCache();
      await file.delete();
      await _prefs.remove(_pathKey);
    }
  }

  Future<void> openFile() async {
    if (fileExists) {
      final file = await _getFileFromCache();
      await OpenFile.open(file.path);
    }
  }
}
