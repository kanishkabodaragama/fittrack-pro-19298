import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_mobile_frontend/main.dart';
import 'package:fitness_mobile_frontend/src/db/app_database.dart';

void main() {
  testWidgets('App shows registration when no account exists', (WidgetTester tester) async {
    final db = await AppDatabase.instance.init();
    
    await tester.pumpWidget(MaterialApp(
      home: FitTrackApp(
        database: db,
        hasAccount: false,
      ),
    ));

    // Verify Material widgets are rendered
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Welcome to FitTrack Pro'), findsOneWidget);
  });

  testWidgets('App shows home shell when account exists', (WidgetTester tester) async {
    final db = await AppDatabase.instance.init();
    
    await tester.pumpWidget(MaterialApp(
      home: FitTrackApp(
        database: db,
        hasAccount: true,
      ),
    ));

    // Verify Material widgets are rendered
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
