import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillify/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:skillify/core/common/app/providers/notifications_notifier.dart';
import 'package:skillify/core/common/app/providers/user_provider.dart';
import 'package:skillify/core/res/colours.dart';
import 'package:skillify/core/res/fonts.dart';
import 'package:skillify/core/services/injection_container.dart';
import 'package:skillify/core/services/router.dart';
import 'package:skillify/credentials.dart';
import 'package:skillify/src/dashboard/providers/dashboard_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Credentials.supabseUrl,
    anonKey: Credentials.supabaseKey,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => CourseOfTheDayNotifier()),
        ChangeNotifierProvider(
          create: (_) => NotificationsNotifier(
            sl<SharedPreferences>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Education App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Fonts.poppins,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
          ),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colours.primaryColour,
          ),
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
