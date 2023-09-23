import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/views/loading_view.dart';
import 'package:skillify/core/common/widgets/gradient_background.dart';
import 'package:skillify/core/common/widgets/nested_back_button.dart';
import 'package:skillify/core/common/widgets/not_found_text.dart';
import 'package:skillify/core/common/widgets/video_tile.dart';
import 'package:skillify/core/res/colours.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/core/utils/core_utils.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/features/videos/presentation/cubit/video_cubit.dart';

class CourseVideosView extends StatefulWidget {
  const CourseVideosView(this.course, {super.key});

  static const routeName = '/course-videos';

  final Course course;

  @override
  State<CourseVideosView> createState() => _CourseVideosViewState();
}

class _CourseVideosViewState extends State<CourseVideosView> {
  void getVideos() {
    context.read<VideoCubit>().getVideos(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const NestedBackButton(),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: BlocConsumer<VideoCubit, VideoState>(
          listener: (_, state) {
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
                'No videos found for ${widget.course.title}',
              );
            } else if (state is VideosLoaded) {
              final videos = state.videos
                ..sort(
                  (a, b) => b.uploadDate.compareTo(a.uploadDate),
                );
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.course.title} Videos',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${state.videos.length} video(s) found',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colours.neutralTextColour,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.videos.length,
                        itemBuilder: (_, index) {
                          return VideoTile(videos[index], tappable: true);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
