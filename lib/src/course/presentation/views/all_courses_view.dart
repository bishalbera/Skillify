import 'package:flutter/material.dart';
import 'package:skillify/core/common/widgets/course_tile.dart';
import 'package:skillify/core/common/widgets/gradient_background.dart';
import 'package:skillify/core/common/widgets/nested_back_button.dart';
import 'package:skillify/core/res/media_res.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/presentation/views/course_details_screen.dart';

class AllCoursesView extends StatelessWidget {
  const AllCoursesView(this.courses, {super.key});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'All Subjects',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: courses
                      .map(
                        (course) => CourseTile(
                          course: course,
                          onTap: () => Navigator.of(context).pushNamed(
                            CourseDetailsScreen.routeName,
                            arguments: course,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
