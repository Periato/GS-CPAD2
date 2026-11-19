
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../services/occurrence_service.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> neighborhoods = [
    'Bairro Central',
    'Jardim das Flores',
    'Vila Nova',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<OccurrenceService>(
      builder: (context, service, child) {
        final occurrences = service.occurrences;

        final affectedNeighborhoods = occurrences
            .map((occurrence) => occurrence.neighborhood)
            .toSet();

        final latestOccurrence = occurrences.isEmpty
            ? null
            : occurrences.reduce(
                (current, next) =>
                    current.date.isAfter(next.date) ? current : next,
              );

        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AlertaBairro',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Inteligência territorial',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/alertas');
                },
                icon: const Icon(Icons.notifications_none),
                tooltip: 'Notificações',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Visão geral',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Acompanhe as condições do seu território.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),

                // Situação atual da cidade
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.white70,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'CIDADE MONITORADA',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Atenção às chuvas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Os dados demonstrativos indicam necessidade '
                        'de acompanhar as condições dos bairros.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Indicadores da cidade',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _buildIndicator(
                        icon: Icons.water_drop_outlined,
                        title: 'Chuva acumulada',
                        value: '42 mm',
                        subtitle: 'Últimas 24 horas',
                        color: AppTheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildIndicator(
                        icon: Icons.flood_outlined,
                        title: 'Ocorrências registradas',
                        value: '${service.totalOccurrences}',
                        subtitle:
                            '${affectedNeighborhoods.length} bairros com registros',
                        color: AppTheme.warning,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  'Situação por bairro',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Classificação baseada nos registros disponíveis.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 14),

                ...neighborhoods.map((neighborhood) {
                  final count = occurrences
                      .where(
                        (occurrence) =>
                            occurrence.neighborhood == neighborhood,
                      )
                      .length;

                  if (count >= 2) {
                    return _buildNeighborhood(
                      neighborhood,
                      'Atenção elevada',
                      count,
                      AppTheme.danger,
                      Icons.warning_amber_rounded,
                    );
                  }

                  if (count == 1) {
                    return _buildNeighborhood(
                      neighborhood,
                      'Atenção moderada',
                      count,
                      AppTheme.warning,
                      Icons.error_outline,
                    );
                  }

                  return _buildNeighborhood(
                    neighborhood,
                    'Sem registros',
                    count,
                    AppTheme.success,
                    Icons.info_outline,
                  );
                }),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'A ausência de registros não significa ausência '
                    'de risco. A classificação é demonstrativa e '
                    'não substitui uma avaliação técnica do território.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Alerta recente',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 14),

                if (latestOccurrence == null)
                  _buildNoAlerts()
                else
                  _buildRecentAlert(latestOccurrence),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Dados demonstrativos para fins acadêmicos',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeighborhood(
    String name,
    String risk,
    int count,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$count ${count == 1 ? 'registro' : 'registros'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            risk,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAlerts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.secondary,
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nenhuma ocorrência foi registrada pelos usuários '
              'até o momento. Continue acompanhando as condições '
              'do território.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAlert(dynamic latest) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.warning,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nova ocorrência registrada',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${latest.neighborhood}: ${latest.description}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Registro informado pelo usuário. '
                  'A avaliação do risco exige análise complementar.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
