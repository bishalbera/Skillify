import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/views/loading_view.dart';
import 'package:skillify/core/common/widgets/not_found_text.dart';
import 'package:skillify/core/common/widgets/video_tile.dart';
import 'package:skillify/core/extensions/context_extension.dart';
import 'package:skillify/core/services/injection_container.dart';
import 'package:skillify/core/utils/core_utils.dart';
import 'package:skillify/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:skillify/src/home/presentation/widgets/section_header.dart';

class HomeVideos extends StatefulWidget {
  const HomeVideos({super.key});

  @override
  State<HomeVideos> createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {
  void getVideos() {
    context.read<VideoCubit>().getVideos(context.courseOfTheDay!.id);
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCubit, VideoState>(
      listener: (context, state) {
        if (state is VideoError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is LoadingVideos) {
          return const LoadingView();
        } else if ((state is VideosLoaded && state.videos.isEmpty) ||
            state is VideoError) {
          return NotFoundText(
            'No videos found for ${context.courseOfTheDay!.title}',
          );
        } else if (state is VideosLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                sectionTitle: '${context.courseOfTheDay!.title} Videos',
                seeAll: state.videos.length > 4,
                onSeeAll: () => context.push(
                  BlocProvider(
                    create: (_) => sl<VideoCubit>(),
                    // child: CourseVideosView(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              for (final video in state.videos.take(5))
                VideoTile(video, tappable: true),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
