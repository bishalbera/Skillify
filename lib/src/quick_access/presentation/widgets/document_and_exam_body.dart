import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillify/core/common/widgets/course_tile.dart';
import 'package:skillify/core/extensions/context_extension.dart';
import 'package:skillify/core/services/injection_container.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:skillify/src/course/features/exams/presentation/views/course_exams_view.dart';
import 'package:skillify/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:skillify/src/course/features/materials/presentation/views/course_materials_view.dart';

class DocumentAndExamBody extends StatelessWidget {
  const DocumentAndExamBody({
    required this.courses,
    required this.index,
    super.key,
  });

  final List<Course> courses;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20).copyWith(top: 0),
      children: [
        Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 40,
            runAlignment: WrapAlignment.spaceEvenly,
            children: courses.map(
              (course) {
                return CourseTile(
                  course: course,
                  onTap: () {
                    context.push(
                      index == 0
                          ? BlocProvider(
                              create: (_) => sl<MaterialCubit>(),
                              child: CourseMaterialsView(course),
                            )
                          : BlocProvider(
                              create: (_) => sl<ExamCubit>(),
                              child: CourseExamsView(course),
                            ),
                    );
                  },
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
