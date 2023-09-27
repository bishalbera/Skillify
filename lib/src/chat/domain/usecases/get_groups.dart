import 'package:skillify/core/usecases/usecases.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/chat/domain/entities/group.dart';
import 'package:skillify/src/chat/domain/repos/chat_repo.dart';

class GetGroups extends StreamUsecaseWithoutParams<List<Group>> {
  const GetGroups(this._repo);

  final ChatRepo _repo;

  @override
  ResultStream<List<Group>> call() => _repo.getGroups();
}
