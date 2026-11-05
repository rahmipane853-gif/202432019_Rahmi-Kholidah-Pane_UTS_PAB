import 'package:flutter_test/flutter_test.dart';
import 'package:findit_app/main.dart';

void main() {
  testWidgets('FindIt app berhasil ditampilkan', (WidgetTester tester) async {
    await tester.pumpWidget(const FindItApp());

    expect(find.text('FindIt'), findsWidgets);
    expect(find.text('Barang Hilang'), findsOneWidget);
    expect(find.text('Barang Ditemukan'), findsOneWidget);
  });
}