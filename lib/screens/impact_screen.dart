
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../services/occurrence_service.dart';
import '../theme/app_theme.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  static const List<String> neighborhoods = [
    'Bairro Central',
    'Jardim das Flores',
    'Vila Nova',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<OccurrenceService>(
      builder: (context, service, child) {
        final totalOccurrences = service.totalOccurrences;

        final neighborhoodsWithRecords = neighborhoods.where((name) {
          return service.occurrences.any(
            (occurrence) => occurrence.neighborhood == name,
          );
        }).length;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Impacto e resposta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Impacto territorial',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Acompanhe os registros e o alcance potencial das ações de prevenção.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        color: Colors.white70,
                        size: 30,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Pessoas potencialmente beneficiadas',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '1.250',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Estimativa demonstrativa para as áreas monitoradas.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Indicadores de acompanhamento',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    _buildIndicator(
                      totalOccurrences.toString(),
                      'Ocorrências registradas',
                      Icons.assignment_outlined,
                      AppTheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    _buildIndicator(
                      '$neighborhoodsWithRecords',
                      'Bairros com registros',
                      Icons.location_on_outlined,
                      AppTheme.warning,
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
                  'Registros locais e recomendações de acompanhamento.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),

                ...neighborhoods.map((neighborhood) {
                  final records = service.occurrences
                      .where(
                        (occurrence) =>
                            occurrence.neighborhood == neighborhood,
                      )
                      .toList();

                  final count = records.length;

                  final Color color;
                  final String status;
                  final String action;

                  if (count >= 2) {
                    color = AppTheme.danger;
                    status = 'Atenção elevada';
                    action = 'Priorizar avaliação das ocorrências e inspeção preventiva.';
                  } else if (count == 1) {
                    color = AppTheme.warning;
                    status = 'Em observação';
                    action = 'Acompanhar o registro e verificar as condições locais.';
                  } else {
                    color = AppTheme.success;
                    status = 'Sem registros';
                    action = 'Manter o monitoramento preventivo da região.';
                  }

                  return _buildNeighborhood(
                    neighborhood,
                    '$count ocorrência(s) registrada(s)',
                    action,
                    status,
                    color,
                  );
                }),

                const SizedBox(height: 28),

                const Text(
                  'Benefício social esperado',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: AppTheme.secondary,
                            size: 26,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Prevenção de alagamentos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'A identificação antecipada de regiões vulneráveis pode ajudar equipes públicas a priorizar inspeções, limpeza de pontos de drenagem e ações de orientação à população.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4E5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.warning,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Os dados e indicadores são demonstrativos. A estimativa de pessoas potencialmente beneficiadas não representa pessoas efetivamente protegidas. Os registros não comprovam que uma ação pública foi executada. A decisão e a resposta final cabem às equipes responsáveis.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

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

  Widget _buildIndicator(
    String value,
    String title,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeighborhood(
    String name,
    String recordSummary,
    String action,
    String status,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            recordSummary,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
