part of 'material_cubit.dart';

abstract class MaterialState extends Equatable {
  const MaterialState();

  @override
  List<Object> get props => [];
}

final class MaterialInitial extends MaterialState {
  const MaterialInitial();
}

class AddingMaterials extends MaterialState {
  const AddingMaterials();
}

class LoadingMaterials extends MaterialState {
  const LoadingMaterials();
}

class MaterialsAdded extends MaterialState {
  const MaterialsAdded();
}

class MaterialsLoaded extends MaterialState {
  const MaterialsLoaded(this.materials);

  final List<Resource> materials;

  @override
  List<Object> get props => [materials];
}

class MaterialError extends MaterialState {
  const MaterialError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
