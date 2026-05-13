import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/controller/dashboard_controller.dart';
import 'features/auth/view/login_view.dart';
import 'features/supervisors/controller/supervisors_controller.dart';
import 'features/stages/controller/stages_controller.dart';
import 'features/approval/controller/approval_controller.dart';
import 'features/research/controller/research_controller.dart';

void main() {
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
