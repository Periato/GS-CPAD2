
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/occurrence.dart';
import '../services/occurrence_service.dart';
import '../theme/app_theme.dart';

class OccurrencesScreen extends StatelessWidget {
  const OccurrencesScreen({super.key});

  static const Map<String, int> initialDistribution = {
    'Bairro Central': 8,
    'Jardim das Flores': 10,
    'Vila Nova': 6,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<OccurrenceService>(
      builder: (context, service, child) {
        final occurrences = service.occurrences;

        final totalInitial = initialDistribution.values.fold<int>(
          0,
          (total, value) => total + value,
        );

        final totalOccurrences = totalInitial + occurrences.length;

        final distribution = <String, int>{};

        for (final neighborhood in initialDistribution.keys) {
          final newRecords = occurrences.where(
            (occurrence) => occurrence.neighborhood == neighborhood,
          ).length;

          distribution[neighborhood] =
              initialDistribution[neighborhood]! + newRecords;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Ocorrências',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Registros territoriais',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Acompanhe as ocorrências registradas nos bairros.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total registrado',
                      '$totalOccurrences',
                      Icons.flood_outlined,
                      AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Novos registros',
                      '${occurrences.length}',
                      Icons.add_alert_outlined,
                      AppTheme.warning,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Distribuição por bairro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Quantidade de ocorrências por região.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),

              _buildNeighborhoodBar(
                'Bairro Central',
                distribution['Bairro Central']!,
                totalOccurrences,
                AppTheme.success,
              ),
              _buildNeighborhoodBar(
                'Jardim das Flores',
                distribution['Jardim das Flores']!,
                totalOccurrences,
                AppTheme.warning,
              ),
              _buildNeighborhoodBar(
                'Vila Nova',
                distribution['Vila Nova']!,
                totalOccurrences,
                AppTheme.danger,
              ),

              const SizedBox(height: 24),

              const Text(
                'Registros recentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 12),

              if (occurrences.isEmpty)
                _buildEmptyState()
              else
                ...occurrences.reversed.map(
                  (occurrence) => _buildOccurrence(occurrence),
                ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'O total combina 24 ocorrências iniciais simuladas com os novos registros cadastrados no aplicativo. Os novos registros são armazenados localmente no dispositivo.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
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
          Icon(icon, color: color, size: 28),
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
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeighborhoodBar(
    String neighborhood,
    int value,
    int maximum,
    Color color,
  ) {
    final progress = maximum > 0 ? value / maximum : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  neighborhood,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '$value ocorrências',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.black12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccurrence(Occurrence occurrence) {
    final date = occurrence.date;

    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} às '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  occurrence.neighborhood,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            occurrence.type,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            occurrence.description,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          if (occurrence.referencePoint.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Referência: ${occurrence.referencePoint}',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 42,
            color: Colors.black38,
          ),
          SizedBox(height: 12),
          Text(
            'Nenhum novo registro',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'As ocorrências cadastradas aparecerão aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
