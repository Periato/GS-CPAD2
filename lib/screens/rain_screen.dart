
import 'package:material_ui/material_ui.dart';

import '../services/rain_data_service.dart';
import '../theme/app_theme.dart';

class RainScreen extends StatefulWidget {
  const RainScreen({super.key});

  @override
  State<RainScreen> createState() => _RainScreenState();
}

class _RainScreenState extends State<RainScreen> {
  final RainDataService _rainService = RainDataService();

  late Future<Map<String, dynamic>> _rainDataFuture;

  @override
  void initState() {
    super.initState();
    _loadRainData();
  }

  void _loadRainData() {
    _rainDataFuture = _rainService.fetchRainData();
  }

  void _retryLoading() {
    setState(() {
      _loadRainData();
    });
  }

  String _getRainClassification(double accumulatedRain) {
    if (accumulatedRain >= 40) return 'Intensidade elevada';
    if (accumulatedRain >= 20) return 'Intensidade moderada';
    return 'Intensidade baixa';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monitoramento de chuvas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _rainDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildError();
          }

          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Carregando dados de precipitação...',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 54,
              color: AppTheme.warning,
            ),
            const SizedBox(height: 16),
            const Text(
              'Não foi possível carregar os dados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifique a conexão e tente novamente.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _retryLoading,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final accumulatedRain =
        (data['accumulatedRain'] as num).toDouble();

    final rainData = List<Map<String, dynamic>>.from(
      data['history'] as List,
    );

    final forecastData = List<Map<String, dynamic>>.from(
      data['forecast'] as List,
    );

    final forecastTotal = forecastData.fold<double>(
      0,
      (total, item) =>
          total + (item['volume'] as num).toDouble(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Condições climáticas',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Acompanhe o volume de precipitação no território.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.water_drop, color: Colors.white70),
                    SizedBox(width: 8),
                    Text(
                      'VOLUME ACUMULADO',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${accumulatedRain.toStringAsFixed(0)} mm',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Precipitação nas últimas 24 horas',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getRainClassification(accumulatedRain),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Histórico de precipitação',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Volume registrado ao longo do dia (mm)',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: rainData.map((item) {
                final value = (item['value'] as num).toDouble();
                final hour = item['hour'] as String;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 17),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 38,
                        child: Text(
                          hour,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (value / 50).clamp(0.0, 1.0),
                            minHeight: 13,
                            backgroundColor: const Color(0xFFE8EFF4),
                            color: value >= 40
                                ? AppTheme.danger
                                : AppTheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 45,
                        child: Text(
                          '${value.toInt()} mm',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Previsão para as próximas horas',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Estimativa de precipitação por horário.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: forecastData.map((item) {
              return _buildForecast(
                item['hour'] as String,
                item['condition'] as String,
                (item['volume'] as num).toDouble(),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.warning.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Atenção às próximas horas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'O volume estimado para o período é de '
                        '${forecastTotal.toStringAsFixed(0)} mm. '
                        'Acompanhe as condições dos bairros '
                        'com histórico de ocorrências.',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
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
                    Text(
                      'Sobre os dados',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Os volumes apresentados são dados sintéticos '
                  'utilizados para demonstração acadêmica. '
                  'Não representam medições meteorológicas reais '
                  'nem previsões oficiais.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A precipitação isoladamente não determina '
                  'a ocorrência de alagamentos. Drenagem, '
                  'relevo, ocupação urbana e condições locais '
                  'também influenciam o risco.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.5,
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
    );
  }

  Widget _buildForecast(
    String hour,
    String condition,
    double volume,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              hour,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Icon(
              volume > 0
                  ? Icons.cloudy_snowing
                  : Icons.cloud_outlined,
              color: AppTheme.secondary,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              condition,
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 5),
            Text(
              '${volume.toInt()} mm',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
