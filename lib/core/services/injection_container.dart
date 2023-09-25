import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillify/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:skillify/src/auth/data/repos/auth_repo_impl.dart';
import 'package:skillify/src/auth/domain/repos/auth_repo.dart';
import 'package:skillify/src/auth/domain/usecases/forgot_password.dart';
import 'package:skillify/src/auth/domain/usecases/sign_in.dart';
import 'package:skillify/src/auth/domain/usecases/sign_up.dart';
import 'package:skillify/src/auth/domain/usecases/update_user.dart';
import 'package:skillify/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillify/src/course/data/datasources/course_remote_data_src.dart';
import 'package:skillify/src/course/data/repos/course_repo_impl.dart';
import 'package:skillify/src/course/domain/repos/course_repo.dart';
import 'package:skillify/src/course/domain/usecases/add_course.dart';
import 'package:skillify/src/course/domain/usecases/get_courses.dart';
import 'package:skillify/src/course/features/exams/data/datasources/exam_remote_data_src.dart';
import 'package:skillify/src/course/features/exams/data/repos/exam_repo_impl.dart';
import 'package:skillify/src/course/features/exams/domain/repos/exam_repo.dart';
import 'package:skillify/src/course/features/exams/domain/usecases/get_exam_questions.dart';
import 'package:skillify/src/course/features/exams/domain/usecases/get_exams.dart';
import 'package:skillify/src/course/features/exams/domain/usecases/get_user_course_exams.dart';
import 'package:skillify/src/course/features/exams/domain/usecases/get_user_exams.dart';
import 'package:skillify/src/course/features/exams/domain/usecases/submit_exam.dart';
import 'package:skillify/src/course/features/exams/domain/usecases/update_exam.dart';
import 'package:skillify/src/course/features/exams/domain/usecases/upload_exam.dart';
import 'package:skillify/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';

import 'package:skillify/src/course/features/materials/data/datasource/material_remote_data_src.dart';
import 'package:skillify/src/course/features/materials/data/repos/material_repo_impl.dart';
import 'package:skillify/src/course/features/materials/domain/repos/material_repo.dart';
import 'package:skillify/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:skillify/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:skillify/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:skillify/src/course/features/materials/presentation/app/providers/resource_controller.dart';

import 'package:skillify/src/course/features/videos/data/datasources/video_remote_data_src.dart';
import 'package:skillify/src/course/features/videos/data/repos/video_repo_impl.dart';
import 'package:skillify/src/course/features/videos/domain/repos/video_repo.dart';
import 'package:skillify/src/course/features/videos/domain/usecases/add_video.dart';
import 'package:skillify/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:skillify/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:skillify/src/course/presentation/cubit/course_cubit.dart';
import 'package:skillify/src/notification/data/datasources/notification_remote_data_src.dart';
import 'package:skillify/src/notification/data/repos/notification_repo_impl.dart';
import 'package:skillify/src/notification/domain/repos/notification_repo.dart';
import 'package:skillify/src/notification/domain/usecases/clear.dart';
import 'package:skillify/src/notification/domain/usecases/clear_all.dart';
import 'package:skillify/src/notification/domain/usecases/get_notification.dart';
import 'package:skillify/src/notification/domain/usecases/mark_as_read.dart';
import 'package:skillify/src/notification/domain/usecases/send_notification.dart';
import 'package:skillify/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:skillify/src/on_boarding/data/dataSources/on_boarding_local_data_sources.dart';
import 'package:skillify/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:skillify/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:skillify/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:skillify/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:skillify/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'injection_container.main.dart';
