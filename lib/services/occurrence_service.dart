
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/occurrence.dart';

class OccurrenceService extends ChangeNotifier {
  static const String _storageKey = 'occurrences';

  final List<Occurrence> _occurrences = [];

  List<Occurrence> get occurrences => List.unmodifiable(_occurrences);

  int get totalOccurrences => _occurrences.length;

  int get pendingOccurrences => _occurrences.length;

  Future<void> loadOccurrences() async {
    final preferences = await SharedPreferences.getInstance();

    final savedData = preferences.getStringList(_storageKey);

    if (savedData == null) {
      _occurrences.clear();
      return;
    }

    final loadedOccurrences = <Occurrence>[];

    for (final item in savedData) {
      final map = jsonDecode(item) as Map<String, dynamic>;

      loadedOccurrences.add(
        Occurrence.fromMap(map),
      );
    }

    _occurrences
      ..clear()
      ..addAll(loadedOccurrences);

    notifyListeners();
  }

  Future<void> addOccurrence(Occurrence occurrence) async {
    _occurrences.add(occurrence);

    try {
      await _saveOccurrences();
    } catch (error) {
      _occurrences.removeWhere(
        (item) => item.id == occurrence.id,
      );

      rethrow;
    }

    notifyListeners();
  }

  Future<void> removeOccurrence(String id) async {
    final index = _occurrences.indexWhere(
      (occurrence) => occurrence.id == id,
    );

    if (index == -1) {
      return;
    }

    final removedOccurrence = _occurrences.removeAt(index);

    try {
      await _saveOccurrences();
    } catch (error) {
      _occurrences.insert(index, removedOccurrence);

      rethrow;
    }

    notifyListeners();
  }

  Future<void> _saveOccurrences() async {
    final preferences = await SharedPreferences.getInstance();

    final savedData = _occurrences
        .map((occurrence) => jsonEncode(occurrence.toMap()))
        .toList();

    final savedSuccessfully = await preferences.setStringList(
      _storageKey,
      savedData,
    );

    if (!savedSuccessfully) {
      throw StateError('Não foi possível salvar as ocorrências.');
    }
  }
}
