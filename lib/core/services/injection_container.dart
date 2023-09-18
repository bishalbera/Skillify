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
import 'package:skillify/src/course/presentation/cubit/course_cubit.dart';
import 'package:skillify/src/on_boarding/data/dataSources/on_boarding_local_data_sources.dart';
import 'package:skillify/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:skillify/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:skillify/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:skillify/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:skillify/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'injection_container.main.dart';
