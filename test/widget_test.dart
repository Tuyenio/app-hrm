import 'package:flutter_test/flutter_test.dart';
import 'package:app_hrm/main.dart';

void main() {
  testWidgets('HRM App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HrmApp());
    await tester.pumpAndSettle();

    // Verify login screen is shown initially
    expect(find.text('Đăng nhập'), findsWidgets);
    expect(find.text('ICS HRM'), findsWidgets);
  });
}
