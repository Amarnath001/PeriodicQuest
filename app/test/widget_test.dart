import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PeriodicQuestApp());
    expect(find.text('Periodic Quest'), findsWidgets);
  });
}
