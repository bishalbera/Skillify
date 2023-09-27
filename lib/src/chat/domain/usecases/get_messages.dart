import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/chat/domain/entities/message.dart';
import 'package:skillify/src/chat/domain/repos/chat_repo.dart';

class GetMessages extends StreamUsecaseWithParams<List<Message>, String> {
  const GetMessages(this._repo);

  final ChatRepo _repo;

  @override
  ResultStream<List<Message>> call(String params) => _repo.getMessages(params);
}
