
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/occurrence.dart';
import '../services/occurrence_service.dart';
import '../theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OccurrenceService>(
      builder: (context, service, child) {
        final neighborhoods = [
          'Bairro Central',
          'Jardim das Flores',
          'Vila Nova',
        ];

        final alerts = neighborhoods.map((neighborhood) {
          final occurrences = service.occurrences
              .where((item) => item.neighborhood == neighborhood)
              .toList();

          occurrences.sort(
            (a, b) => b.date.compareTo(a.date),
          );

          return {
            'neighborhood': neighborhood,
            'count': occurrences.length,
            'latest': occurrences.isNotEmpty
                ? occurrences.first
                : null,
          };
        }).where((alert) => (alert['count'] as int) > 0).toList();

        alerts.sort(
          (a, b) => (b['count'] as int).compareTo(
            a['count'] as int,
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Central de Alertas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Monitoramento de riscos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Acompanhe os alertas gerados a partir das '
                'ocorrências registradas nos bairros.',
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Resumo dos alertas
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Alertas ativos',
                      '${alerts.length}',
                      Icons.notifications_active_outlined,
                      AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Registros analisados',
                      '${service.totalOccurrences}',
                      Icons.analytics_outlined,
                      AppTheme.warning,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Alertas por bairro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 14),

              if (alerts.isEmpty)
                _buildEmptyState()
              else
                ...alerts.map((alert) {
                  final count = alert['count'] as int;
                  final neighborhood =
                      alert['neighborhood'] as String;
                  final latest = alert['latest'] as Occurrence;

                  final isHigh = count >= 2;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildAlert(
                      neighborhood: neighborhood,
                      count: count,
                      latest: latest,
                      level: isHigh
                          ? 'ATENÇÃO ELEVADA'
                          : 'ATENÇÃO MODERADA',
                      color: isHigh
                          ? AppTheme.danger
                          : AppTheme.warning,
                    ),
                  );
                }),

              const SizedBox(height: 8),

              _buildExplanation(),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'AlertaBairro | Inteligência territorial',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlert({
    required String neighborhood,
    required int count,
    required Occurrence latest,
    required String level,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  neighborhood,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    level,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Evidências identificadas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 19,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$count ocorrência(s) registrada(s) neste bairro.',
                  style: const TextStyle(height: 1.4),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 19,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Registro mais recente: ${latest.description}',
                  style: const TextStyle(height: 1.4),
                ),
              ),
            ],
          ),

          if (latest.referencePoint.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 19,
                  color: AppTheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Referência: ${latest.referencePoint}',
                    style: const TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),

          Text(
            'Registrado em: ${_formatDate(latest.date)}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),

          const Divider(height: 28),

          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 19,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Confiança da análise',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              Text(
                'Baixa',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Limitações da análise',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            'O alerta considera a quantidade de registros '
            'informados no aplicativo. Ainda não utiliza '
            'previsões meteorológicas, intensidade da chuva '
            'ou histórico completo de alagamentos.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.primary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Como os alertas são gerados?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'O sistema utiliza uma regra demonstrativa baseada '
            'na quantidade de ocorrências registradas em cada bairro:',
            style: TextStyle(height: 1.5),
          ),
          SizedBox(height: 10),
          Text(
            '• 1 registro: atenção moderada.\n'
            '• 2 ou mais registros: atenção elevada.',
            style: TextStyle(height: 1.7),
          ),
          SizedBox(height: 12),
          Text(
            'A confiança da análise é baixa, pois a quantidade '
            'de registros não representa, isoladamente, a '
            'probabilidade real de alagamento. É necessário '
            'considerar também as condições climáticas, '
            'o histórico e o contexto territorial.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Os alertas servem como apoio à análise. A avaliação '
            'das informações e a decisão final cabem às pessoas '
            'responsáveis.',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.notifications_none,
            size: 44,
            color: Colors.black38,
          ),
          SizedBox(height: 12),
          Text(
            'Nenhum novo alerta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Novos alertas aparecerão conforme as ocorrências '
            'forem registradas nos bairros.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year às $hour:$minute';
  }
}
