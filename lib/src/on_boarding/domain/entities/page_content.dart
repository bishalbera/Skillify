import 'package:equatable/equatable.dart';
import 'package:skillify/core/res/media_res.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.animation,
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
          animation: MediaRes.shapes,
          image: MediaRes.spline,
          title: 'Brand new curriculum',
          description:
              ' We have a brand new curriculum that will help you learn the skills '
              'you need to get a job in the tech industry.',
        );

  const PageContent.second()
      : this(
          animation: MediaRes.shapes,
          image: MediaRes.spline,
          title: 'Brand new curriculum',
          description:
              ' We have a brand new curriculum that will help you learn the skills '
              'you need to get a job in the tech industry.',
        );

  const PageContent.third()
      : this(
          animation: MediaRes.shapes,
          image: MediaRes.spline,
          title: 'Brand new curriculum',
          description:
              ' We have a brand new curriculum that will help you learn the skills '
              'you need to get a job in the tech industry.',
        );

  final String animation;
  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [animation, image, title, description];
}
