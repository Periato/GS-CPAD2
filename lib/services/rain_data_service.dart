
class RainDataService {
  Future<Map<String, dynamic>> fetchRainData() async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      'accumulatedRain': 42.0,
      'history': [
        {'hour': '08h', 'value': 12.0},
        {'hour': '10h', 'value': 22.0},
        {'hour': '12h', 'value': 35.0},
        {'hour': '14h', 'value': 28.0},
        {'hour': '16h', 'value': 42.0},
        {'hour': '18h', 'value': 30.0},
      ],
      'forecast': [
        {'hour': '19h', 'condition': 'Chuva', 'volume': 12.0},
        {'hour': '21h', 'condition': 'Nublado', 'volume': 4.0},
        {'hour': '23h', 'condition': 'Nublado', 'volume': 0.0},
      ],
    };
  }
}
