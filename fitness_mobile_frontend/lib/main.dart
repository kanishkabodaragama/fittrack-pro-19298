import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/app_theme.dart';
import 'src/core/app_state.dart';
import 'src/db/app_database.dart';
import 'src/features/auth/registration_screen.dart';
import 'src/features/shell/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database before app start
  final db = await AppDatabase.instance.init();

  // Load simple persisted value for onboarding/auth
  final prefs = await SharedPreferences.getInstance();
  final hasAccount = prefs.getBool('has_account') ?? false;

  runApp(FitTrackApp(database: db, hasAccount: hasAccount));
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({
    super.key,
    required this.database,
    required this.hasAccount,
  });

  final AppDatabase database;
  final bool hasAccount;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(database),
        ),
      ],
      child: MaterialApp(
        title: 'FitTrack Pro',
        debugShowCheckedModeBanner: false,
        theme: buildOceanPlayfulTheme(),
        home: hasAccount ? const HomeShell() : const RegistrationScreen(),
      ),
    );
  }
}
