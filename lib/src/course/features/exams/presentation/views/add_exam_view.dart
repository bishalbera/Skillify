import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/widgets/course_picker.dart';
import 'package:skillify/core/enums/notification_enum.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/core/utils/core_utils.dart';
import 'package:skillify/core/utils/typedef.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/features/exams/data/models/exam_model.dart';
import 'package:skillify/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:skillify/src/notification/presentation/widgets/notification_wrapper.dart';
import 'package:uuid/uuid.dart';

class AddExamView extends StatefulWidget {
  const AddExamView({super.key});

  static const routeName = '/add-exam';

  @override
  State<AddExamView> createState() => _AddExamViewState();
}

class _AddExamViewState extends State<AddExamView> {
  File? examFile;

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  Future<void> pickExamFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      setState(() {
        examFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadExam() async {
    if (examFile == null) {
      return CoreUtils.showSnackBar(context, 'Please pick an exam to upload');
    }
    if (formKey.currentState!.validate()) {
      final json = examFile!.readAsStringSync();
      final jsonMap = jsonDecode(json) as DataMap;
      final exam = ExamModel.fromUploadMap(jsonMap).copyWith(
        courseId: courseNotifier.value!.id,
        id: const Uuid().v4(),
      );
      print(exam.id);
      await context.read<ExamCubit>().uploadExam(exam);
    }
  }

  bool showingDialog = false;

  @override
  void dispose() {
    courseController.dispose();
    courseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.of(context).pop();
      },
      child: BlocListener<ExamCubit, ExamState>(
        listener: (_, state) {
          if (showingDialog == true) {
            Navigator.pop(context);
            showingDialog = false;
          }
          if (state is UploadingExam) {
            CoreUtils.showLoadingDialog(context);
            showingDialog = true;
          } else if (state is ExamError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is ExamUploaded) {
            CoreUtils.showSnackBar(context, 'Exam uploaded successfully');
            CoreUtils.sendNotification(
              context,
              title: 'New ${courseNotifier.value!.title} exam',
              body: 'A new exam has been added for '
                  '${courseNotifier.value!.title}',
              category: NotificationCategory.TEST,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Add Exam')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: CoursePicker(
                        controller: courseController,
                        notifier: courseNotifier,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (examFile != null) ...[
                      const SizedBox(height: 10),
                      Card(
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Image.asset(MediaRes.json),
                          ),
                          title: Text(examFile!.path.split('/').last),
                          trailing: IconButton(
                            onPressed: () => setState(() {
                              examFile = null;
                            }),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: pickExamFile,
                          child: Text(
                            examFile == null
                                ? 'Select Exam File'
                                : 'Replace Exam File',
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: uploadExam,
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
