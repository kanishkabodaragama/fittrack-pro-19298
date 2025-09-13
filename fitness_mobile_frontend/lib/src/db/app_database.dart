import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';
import '../models/workout.dart';
import '../models/goal.dart';

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();

  late Database _db;

  // DAOs
  late final UserDao userDao;
  late final WorkoutDao workoutDao;
  late final GoalDao goalDao;

  Future<AppDatabase> init() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'fittrack_pro.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    userDao = UserDao(_db);
    workoutDao = WorkoutDao(_db);
    goalDao = GoalDao(_db);

    return this;
  }

  Database get raw => _db;

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE workouts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        notes TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE goals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        target INTEGER NOT NULL,
        progress INTEGER NOT NULL DEFAULT 0,
        completed INTEGER NOT NULL DEFAULT 0
      );
    ''');
  }
}

// PUBLIC_INTERFACE
class UserDao {
  /// Data access object for the users table.
  UserDao(this.db);
  final Database db;

  // PUBLIC_INTERFACE
  Future<User?> getFirstUser() async {
    /** Returns the first user if exists, otherwise null. */
    final rows = await db.query('users', limit: 1);
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  // PUBLIC_INTERFACE
  Future<int> insert(User user) async {
    /** Inserts a user and returns new id. */
    return db.insert('users', user.toMap());
  }

  // PUBLIC_INTERFACE
  Future<User> upsert(User user) async {
    /** Upserts a user by email. */
    final existing = await db.query('users', where: 'email = ?', whereArgs: [user.email], limit: 1);
    if (existing.isEmpty) {
      final id = await insert(user);
      return user.copyWith(id: id);
    } else {
      final id = existing.first['id'] as int;
      final updated = user.copyWith(id: id);
      await db.update('users', updated.toMap(), where: 'id = ?', whereArgs: [id]);
      return updated;
    }
  }
}

// PUBLIC_INTERFACE
class WorkoutDao {
  /// Data access object for the workouts table.
  WorkoutDao(this.db);
  final Database db;

  // PUBLIC_INTERFACE
  Future<int> insert(Workout workout) async {
    /** Inserts a workout and returns id. */
    return db.insert('workouts', workout.toMap());
  }

  // PUBLIC_INTERFACE
  Future<List<Workout>> findAll({int? limit}) async {
    /** Returns all workouts ordered by date desc. */
    final rows = await db.query('workouts', orderBy: 'date DESC', limit: limit);
    return rows.map(Workout.fromMap).toList();
  }

  // PUBLIC_INTERFACE
  Future<int> countAll() async {
    /** Returns total number of workouts. */
    final res = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM workouts'));
    return res ?? 0;
  }
}

// PUBLIC_INTERFACE
class GoalDao {
  /// Data access object for the goals table.
  GoalDao(this.db);
  final Database db;

  // PUBLIC_INTERFACE
  Future<int> insert(Goal goal) async {
    /** Inserts a goal and returns id. */
    return db.insert('goals', goal.toMap());
  }

  // PUBLIC_INTERFACE
  Future<void> update(Goal goal) async {
    /** Updates a goal by id. */
    await db.update('goals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  // PUBLIC_INTERFACE
  Future<List<Goal>> findAll() async {
    /** Returns all goals. */
    final rows = await db.query('goals', orderBy: 'completed ASC, id DESC');
    return rows.map(Goal.fromMap).toList();
  }

  // PUBLIC_INTERFACE
  Future<int> countCompleted() async {
    /** Returns completed goals count. */
    final res = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM goals WHERE completed = 1'));
    return res ?? 0;
  }
}
