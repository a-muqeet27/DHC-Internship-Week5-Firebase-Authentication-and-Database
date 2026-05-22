// This is a basic Flutter widget test.
//
// The app depends on Firebase, so this smoke test only verifies that a basic
// Flutter widget can be built successfully in the test environment.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Test')),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}
