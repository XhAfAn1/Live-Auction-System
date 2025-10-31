import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import your main application file
import 'package:liveauctionsystem/main.dart'; 

void main() {
  // Use a descriptive name for the group of tests
  group('MyApp Home Page Counter Tests 🧪', () {

    // --- Test 1: Initial State Verification ---
    testWidgets('Verify initial state: title, default text, and count of 0', (WidgetTester tester) async {
      // 1. Build the widget and wait for all frames to render
      await tester.pumpWidget(const MyApp());

      // 2. Verify Key UI Elements
      
      // Check the App Bar title
      expect(find.text('Flutter Demo Home Page'), findsOneWidget, 
        reason: 'Should find the App Bar title text.');
      
      // Check the default explanatory text
      expect(find.text('You have pushed the button this many times:'), findsOneWidget, 
        reason: 'Should find the explanatory text above the counter.');

      // Check the initial counter value
      expect(find.text('0'), findsOneWidget, 
        reason: 'Counter must start at 0.');
      expect(find.text('1'), findsNothing, 
        reason: 'Counter must not show 1 initially.');
    });

    // --- Test 2: Single Increment Action ---
    testWidgets('Single tap on Floating Action Button (FAB) should increment counter to 1', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Find the FAB by its icon
      final fabFinder = find.byIcon(Icons.add);
      expect(fabFinder, findsOneWidget, reason: 'Must find the Floating Action Button.');

      // Tap the FAB
      await tester.tap(fabFinder);
      // Rebuild the widget tree (usually triggers an animation/state change)
      await tester.pump();

      // Verify the incremented state
      expect(find.text('0'), findsNothing, 
        reason: 'Counter value 0 should be gone.');
      expect(find.text('1'), findsOneWidget, 
        reason: 'Counter value should now be 1.');
    });

    // --- Test 3: Multiple Increment Actions ---
    testWidgets('Multiple taps on FAB should increment counter correctly (to 3)', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final fabFinder = find.byIcon(Icons.add);

      // Tap 3 times
      await tester.tap(fabFinder); // -> 1
      await tester.pump();
      expect(find.text('1'), findsOneWidget, reason: 'After 1 tap, counter should be 1.');

      await tester.tap(fabFinder); // -> 2
      await tester.pump();
      expect(find.text('2'), findsOneWidget, reason: 'After 2 taps, counter should be 2.');
      
      await tester.tap(fabFinder); // -> 3
      // Use pumpAndSettle() here to ensure any animation is complete, 
      // although pump() is often sufficient for simple state changes.
      await tester.pumpAndSettle(); 
      
      // Final verification
      expect(find.text('3'), findsOneWidget, reason: 'After 3 taps, counter should be 3.');
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsNothing);
    });
  });
}
