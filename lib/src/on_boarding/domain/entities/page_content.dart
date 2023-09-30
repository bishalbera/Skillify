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
          description: ' Upgrade your skills with skillify ',
        );

  const PageContent.second()
      : this(
          animation: MediaRes.shapes,
          image: MediaRes.spline,
          title: 'Brand new curriculum',
          description: ' Skillify will help you to upskill so  '
              'you  get a job in the tech industry.',
        );

  const PageContent.third()
      : this(
          animation: MediaRes.shapes,
          image: MediaRes.spline,
          title: 'Brand new curriculum',
          description: ' Join diverse community, '
              'give exams and lot more. ',
        );

  final String animation;
  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [animation, image, title, description];
}
