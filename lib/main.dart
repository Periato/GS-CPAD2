
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/rain_screen.dart';
import 'screens/occurrences_screen.dart';
import 'screens/impact_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/register_occurrence_screen.dart';
import 'services/occurrence_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final occurrenceService = OccurrenceService();

  await occurrenceService.loadOccurrences();

  runApp(
    ChangeNotifierProvider.value(
      value: occurrenceService,
      child: const AlertaBairroApp(),
    ),
  );
}

class AlertaBairroApp extends StatelessWidget {
  const AlertaBairroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlertaBairro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/inicio': (context) => const HomeScreen(),
        '/chuvas': (context) => const RainScreen(),
        '/ocorrencias': (context) => const OccurrencesScreen(),
        '/impacto': (context) => const ImpactScreen(),
        '/alertas': (context) => const AlertsScreen(),
        '/registrar': (context) => const RegisterOccurrenceScreen(),
      },
    );
  }
}
