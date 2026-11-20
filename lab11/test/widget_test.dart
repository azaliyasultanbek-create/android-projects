
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/main.dart';

void main() {
  testWidgets('AZI Cosmetics app test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MyApp(
        isDarkMode: false,
        username: 'Guest User',
      ),
    );

    expect(find.text('AZI Cosmetics'), findsOneWidget);
  });
}
