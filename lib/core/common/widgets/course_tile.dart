import 'package:flutter/material.dart';
import 'package:skillify/src/course/domain/entities/course.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({required this.course, super.key, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          children: [
            SizedBox(
              height: 54,
              width: 54,
              child: Image.network(
                course.image!,
                height: 32,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              course.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
