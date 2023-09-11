import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ],
      child: MaterialApp(
        title: 'Skillify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch(accentColor: Colours.primaryColour),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Fonts.poppins,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
