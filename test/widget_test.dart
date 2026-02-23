import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_pdf_scanner/app.dart';

void main() {
  testWidgets('Smart PDF Scanner app builds without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Basic smoke test: expect AppBar title to be present.
    expect(find.text('Smart PDF Scanner'), findsOneWidget);
  });
}
