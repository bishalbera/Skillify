import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillify/core/common/views/page_under_construction.dart';
import 'package:skillify/core/extensions/context_extension.dart';
import 'package:skillify/core/services/injection_container.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:skillify/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillify/src/auth/presentation/views/sign_in_screen.dart';
import 'package:skillify/src/auth/presentation/views/sign_up_screen.dart';
import 'package:skillify/src/course/domain/entities/course.dart';
import 'package:skillify/src/course/features/exams/domain/entities/exam.dart';
import 'package:skillify/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:skillify/src/course/features/exams/presentation/app/providers/exam_controller.dart';

import 'package:skillify/src/course/features/exams/presentation/views/add_exam_view.dart';
import 'package:skillify/src/course/features/exams/presentation/views/course_exams_view.dart';
import 'package:skillify/src/course/features/exams/presentation/views/exam_details_view.dart';
import 'package:skillify/src/course/features/exams/presentation/views/exam_view.dart';

import 'package:skillify/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:skillify/src/course/features/materials/presentation/views/add_materials_view.dart';
import 'package:skillify/src/course/features/materials/presentation/views/course_materials_view.dart';

import 'package:skillify/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:skillify/src/course/features/videos/presentation/views/add_video_view.dart';
import 'package:skillify/src/course/features/videos/presentation/views/course_videos_view.dart';
import 'package:skillify/src/course/features/videos/presentation/views/video_player_view.dart';
import 'package:skillify/src/course/presentation/cubit/course_cubit.dart';
import 'package:skillify/src/course/presentation/views/course_details_screen.dart';
import 'package:skillify/src/dashboard/presentation/views/dashboard.dart';
import 'package:skillify/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:skillify/src/on_boarding/data/dataSources/on_boarding_local_data_sources.dart';
import 'package:skillify/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:skillify/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

part 'router.main.dart';
