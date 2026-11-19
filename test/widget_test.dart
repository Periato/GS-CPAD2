// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alerta_bairro/main.dart';
import 'package:alerta_bairro/services/occurrence_service.dart';

void main() {
  testWidgets(
    'O aplicativo inicia e permite navegar para a tela de chuvas',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final occurrenceService = OccurrenceService();
      await occurrenceService.loadOccurrences();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: occurrenceService,
          child: const AlertaBairroApp(),
        ),
      );

      expect(find.text('Início'), findsOneWidget);

      await tester.tap(find.text('Chuvas'));

      // Aguarda o carregamento dos dados simulados.
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      expect(navigationBar.selectedIndex, 1);
      expect(find.text('Monitoramento de chuvas'), findsOneWidget);
    },
  );
}
