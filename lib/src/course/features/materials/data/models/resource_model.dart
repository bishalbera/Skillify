import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/features/materials/domain/entities/resource.dart';

class ResourceModel extends Resource {
  const ResourceModel({
    required super.id,
    required super.courseId,
    required super.uploadDate,
    required super.fileURL,
    required super.fileExtension,
    required super.isFile,
    required super.fileSize,
    super.title,
    super.author,
    super.description,
  });

  ResourceModel.empty([DateTime? date])
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          uploadDate: date ?? DateTime.now(),
          fileExtension: '_empty.fileExtension',
          isFile: true,
          courseId: '_empty.courseId',
          fileURL: '_empty.fileURL',
          author: '_empty.author',
          fileSize: 0,
        );

  ResourceModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String?,
          description: map['description'] as String?,
          uploadDate: DateTime.parse(map['uploadDate'] as String),
          fileExtension: map['fileExtension'] as String,
          isFile: map['isFile'] as bool,
          courseId: map['courseId'] as String,
          fileURL: map['fileURL'] as String,
          author: map['author'] as String?,
          fileSize: map['fileSize'] as int,
        );

  ResourceModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? uploadDate,
    String? fileExtension,
    bool? isFile,
    String? courseId,
    String? fileURL,
    String? author,
    int? fileSize,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      uploadDate: uploadDate ?? this.uploadDate,
      courseId: courseId ?? this.courseId,
      fileURL: fileURL ?? this.fileURL,
      isFile: isFile ?? this.isFile,
      author: author ?? this.author,
      fileExtension: fileExtension ?? this.fileExtension,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'uploadDate': DateTime.now().toUtc().toIso8601String(),
      'courseId': courseId,
      'fileURL': fileURL,
      'author': author,
      'isFile': isFile,
      'fileExtension': fileExtension,
      'fileSize': fileSize,
    };
  }
}
