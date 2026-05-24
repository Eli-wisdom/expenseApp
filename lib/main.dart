import 'dart:io';

import 'package:expense_app/provider/expense_provider.dart';
import 'package:expense_app/screens/account_screen.dart';
import 'package:expense_app/screens/chat_screen.dart';
import 'package:expense_app/screens/login_screen.dart';
import 'package:expense_app/screens/splash_screen.dart';
import 'package:expense_app/widgets/currencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/theme.dart';
import 'widgets/scaffold_with_nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/share_screen.dart';
import 'screens/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://htlumlkpicijactqnnuq.supabase.co',
    anonKey: 'sb_publishable_5K6bphRust_26ziU3rf13g_DCTuCu-c',
  );

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const ProviderScope(child: ExpenseApp()));
}

final supabase = Supabase.instance.client;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/currencies',
      builder: (context, state) => const CurrencyScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/analysis',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: AnalysisScreen()),
        ),
        GoRoute(
          path: '/share',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: ShareScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder:
              (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),
  ],
);

class ExpenseApp extends ConsumerStatefulWidget {
  const ExpenseApp({super.key});

  @override
  ConsumerState<ExpenseApp> createState() => _ExpenseAppState();
}

class _ExpenseAppState extends ConsumerState<ExpenseApp> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Future.microtask(_loadInitialData);
    }
  }

  Future<void> _loadInitialData() async {
    await ref.read(accountNotifierProvider.notifier).loadAccount();
    await ref.read(categoryNotifierProvider.notifier).loadCategory();
    await ref.read(expenseNotifierProvider.notifier).loadExpense();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SYS_CORE_V1.0',
      theme: CyberTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
