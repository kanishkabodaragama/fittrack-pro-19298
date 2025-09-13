import 'package:flutter/foundation.dart';
import '../db/app_database.dart';
import '../models/goal.dart';
import '../models/user.dart';
import '../models/workout.dart';

/// Simple global app state holding cached entities counts and active user.
class AppState extends ChangeNotifier {
  AppState(this.db);

  final AppDatabase db;

  User? _activeUser;
  int _totalWorkouts = 0;
  int _completedGoals = 0;

  User? get activeUser => _activeUser;
  int get totalWorkouts => _totalWorkouts;
  int get completedGoals => _completedGoals;

  Future<void> loadInitial() async {
    _activeUser = await db.userDao.getFirstUser();
    _totalWorkouts = await db.workoutDao.countAll();
    _completedGoals = await db.goalDao.countCompleted();
    notifyListeners();
  }

  Future<void> setActiveUser(User user) async {
    _activeUser = user;
    notifyListeners();
  }

  Future<void> refreshDashboard() async {
    _totalWorkouts = await db.workoutDao.countAll();
    _completedGoals = await db.goalDao.countCompleted();
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    await db.workoutDao.insert(workout);
    await refreshDashboard();
  }

  Future<void> addGoal(Goal goal) async {
    await db.goalDao.insert(goal);
    await refreshDashboard();
  }

  Future<void> toggleGoal(Goal goal) async {
    final updated = goal.copyWith(completed: !goal.completed);
    await db.goalDao.update(updated);
    await refreshDashboard();
  }

  Future<void> updateUser(User user) async {
    await db.userDao.upsert(user);
    _activeUser = user;
    notifyListeners();
  }
}
