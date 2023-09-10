import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillify/core/common/views/page_under_construction.dart';
import 'package:skillify/core/extensions/context_extension.dart';
import 'package:skillify/core/services/injection_container.dart';
import 'package:skillify/src/auth/data/models/user_model.dart';
import 'package:skillify/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillify/src/auth/presentation/views/sign_in_screen.dart';
import 'package:skillify/src/auth/presentation/views/sign_up_screen.dart';
import 'package:skillify/src/dashboard/presentation/views/dashboard.dart';
import 'package:skillify/src/on_boarding/data/dataSources/on_boarding_local_data_sources.dart';
import 'package:skillify/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:skillify/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'router.main.dart';
