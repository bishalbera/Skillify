import 'package:flutter/material.dart';
import 'package:skillify/core/extensions/string_extension.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/features/videos/data/models/video_model.dart';

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  static const routeName = '/add-video';

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  final urlController = TextEditingController();
  final authorController = TextEditingController(text: '');
  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  final formKey = GlobalKey<FormState>();

  VideoModel? video;

  final authorFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final urlFocusNode = FocusNode();

  bool getMoreDetails = false;

  bool get isYoutube => urlController.text.trim().isYoutubeVideo;

  bool thumbNailIsFile = false;
  bool loading = false;
  bool showingDialog = false;

  void reset() {
    setState(() {
      urlController.clear();
      authorController.text = '';
      titleController.clear();
      getMoreDetails = false;
      loading = false;
      video = null;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.addListener(() {
      if (urlController.text.trim().isEmpty) reset();
    });
    authorController.addListener(() {
      video = video?.copyWith(tutor: authorController.text.trim());
    });
    titleController.addListener(() {
      video = video?.copyWith(title: titleController.text.trim());
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    authorController.dispose();
    titleController.dispose();
    courseController.dispose();
    courseNotifier.dispose();
    urlFocusNode.dispose();
    titleFocusNode.dispose();
    authorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
