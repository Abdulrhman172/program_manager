import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/controller/dashboard_controller.dart';
import 'features/auth/view/login_view.dart';
import 'features/supervisors/controller/supervisors_controller.dart';
import 'features/stages/controller/stages_controller.dart';
import 'features/approval/controller/approval_controller.dart';
import 'features/research/controller/research_controller.dart';
import 'features/teams/controller/teams_controller.dart';
import 'features/grades/controller/grades_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://quakwoghhxoobcgcknsj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1YWt3b2doaHhvb2JjZ2NrbnNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0MjAyNTMsImV4cCI6MjA4MTk5NjI1M30.OYmQVRGhirs7cJDI64rRqQZss6RDnof8kABlZNQDHbA',
  );

  runApp(const CoordinatorApp());
}

class CoordinatorApp extends StatelessWidget {
  const CoordinatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => SupervisorsController()),
        ChangeNotifierProvider(create: (_) => StagesController()),
        ChangeNotifierProvider(create: (_) => ApprovalController()),
        ChangeNotifierProvider(create: (_) => ResearchController()),
        ChangeNotifierProvider(create: (_) => TeamsController()),
        ChangeNotifierProvider(create: (_) => GradesController()),
      ],
      child: MaterialApp(
        title: 'نظام إدارة بحوث التخرج',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: const Locale('ar', 'SA'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        home: const LoginView(),
      ),
    );
  }
}
