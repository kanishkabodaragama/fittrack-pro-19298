import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/app_state.dart';
import '../tabs/dashboard/dashboard_screen.dart';
import '../tabs/workouts/workouts_screen.dart';
import '../tabs/goals/goals_screen.dart';
import '../tabs/profile/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    WorkoutsScreen(),
    GoalsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Safe: no BuildContext operations after await; load quickly
    Future.microtask(() {
      final app = context.read<AppState>();
      app.loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildOceanGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _index,
          children: _pages,
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: 'Workouts'),
              BottomNavigationBarItem(icon: Icon(Icons.flag_rounded), label: 'Goals'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
