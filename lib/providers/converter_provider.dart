import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/services/storage_service.dart';
import '../models/unit_catalog.dart';

class ConverterProvider extends ChangeNotifier {
  static const _onboardingKey = 'unp_onboarding_done';
  static const _stateKey = 'unp_converter_state';
  static const _favKey = 'unp_favorites';
  static const _histKey = 'unp_history';
  static const _weekKey = 'unp_week_converts';
  static const _weekStartKey = 'unp_week_start';
  static const _streakKey = 'unp_convert_streak';
  static const _lastDayKey = 'unp_last_convert_day';

  var _categoryId = 'length';
  var _fromId = 'km';
  var _toId = 'mi';
  var _input = '5';
  var _onboardingComplete = false;
  var _weekConverts = 0;
  var _streak = 0;
  List<ConversionPair> _favorites = [];
  List<ConversionRecord> _history = [];
  var _initialized = false;

  bool get onboardingComplete => _onboardingComplete;
  String get categoryId => _categoryId;
  String get fromId => _fromId;
  String get toId => _toId;
  String get input => _input;
  int get weekConverts => _weekConverts;
  int get streak => _streak;
  List<ConversionPair> get favorites => List.unmodifiable(_favorites);
  List<ConversionRecord> get history => List.unmodifiable(_history);

  UnitCategory get category => UnitCatalog.get(_categoryId);
  MeasureUnit get fromUnit => category.unit(_fromId);
  MeasureUnit get toUnit => category.unit(_toId);

  double? get inputValue => double.tryParse(_input.replaceAll(',', ''));

  String output({int decimals = 6}) {
    final v = inputValue;
    if (v == null) return '';
    return UnitCatalog.format(
        UnitCatalog.convert(from: fromUnit, to: toUnit, value: v),
        decimals: decimals);
  }

  bool isFavoritePair(ConversionPair pair) =>
      _favorites.any((f) => f.key == pair.key);

  ConversionPair get currentPair =>
      ConversionPair(categoryId: _categoryId, fromId: _fromId, toId: _toId);

  Future<void> init() async {
    if (_initialized) return;
    _onboardingComplete =
        await StorageService.instance.getBool(_onboardingKey) ?? false;
    final raw = await StorageService.instance.getData(_stateKey);
    if (raw != null) {
      _categoryId = raw['category']?.toString() ?? _categoryId;
      _fromId = raw['from']?.toString() ?? _fromId;
      _toId = raw['to']?.toString() ?? _toId;
      _input = raw['input']?.toString() ?? _input;
    }
    final fav = await StorageService.instance.getStringList(_favKey) ?? [];
    _favorites = fav.map(ConversionPair.decode).toList();
    final hist = await StorageService.instance.getStringList(_histKey) ?? [];
    _history = hist
        .map((s) {
          try {
            return ConversionRecord.fromJson(
                jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<ConversionRecord>()
        .toList();
    _weekConverts = await StorageService.instance.getInt(_weekKey) ?? 0;
    _streak = await StorageService.instance.getInt(_streakKey) ?? 0;
    await _rollWeek();
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    await StorageService.instance.saveBool(_onboardingKey, true);
    notifyListeners();
  }

  Future<void> setCategory(String id) async {
    if (_categoryId == id) return;
    final cat = UnitCatalog.get(id);
    _categoryId = cat.id;
    _fromId = cat.units.first.id;
    _toId = cat.units.length > 1 ? cat.units[1].id : cat.units.first.id;
    await _saveState();
    notifyListeners();
  }

  Future<void> setFrom(String id) async {
    _fromId = id;
    if (_fromId == _toId) {
      final other = category.units
          .firstWhere((u) => u.id != id, orElse: () => category.units.first);
      _toId = other.id;
    }
    await _saveState();
    notifyListeners();
  }

  Future<void> setTo(String id) async {
    _toId = id;
    if (_toId == _fromId) {
      final other = category.units
          .firstWhere((u) => u.id != id, orElse: () => category.units.first);
      _fromId = other.id;
    }
    await _saveState();
    notifyListeners();
  }

  Future<void> setInput(String value) async {
    _input = value;
    await _saveState();
    notifyListeners();
  }

  Future<void> swap() async {
    final a = _fromId;
    _fromId = _toId;
    _toId = a;
    final out = output();
    if (out.isNotEmpty) _input = out;
    await _saveState();
    await logConversion();
  }

  Future<void> applyPair(ConversionPair pair) async {
    _categoryId = pair.categoryId;
    _fromId = pair.fromId;
    _toId = pair.toId;
    await _saveState();
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final pair = currentPair;
    if (isFavoritePair(pair)) {
      _favorites.removeWhere((f) => f.key == pair.key);
    } else {
      _favorites.insert(0, pair);
    }
    await StorageService.instance
        .saveStringList(_favKey, _favorites.map((f) => f.key).toList());
    notifyListeners();
  }

  Future<void> removeFavorite(ConversionPair pair) async {
    _favorites.removeWhere((f) => f.key == pair.key);
    await StorageService.instance
        .saveStringList(_favKey, _favorites.map((f) => f.key).toList());
    notifyListeners();
  }

  Future<void> logConversion() async {
    final v = inputValue;
    if (v == null) return;
    final record = ConversionRecord(
      pair: currentPair,
      input: UnitCatalog.format(v),
      output: output(),
      atMs: DateTime.now().millisecondsSinceEpoch,
    );
    _history.removeWhere(
        (h) => h.pair.key == record.pair.key && h.input == record.input);
    _history.insert(0, record);
    if (_history.length > 80) _history = _history.sublist(0, 80);
    await StorageService.instance.saveStringList(
        _histKey, _history.map((h) => jsonEncode(h.toJson())).toList());
    await _touchStreak();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    await StorageService.instance.saveStringList(_histKey, []);
    notifyListeners();
  }

  Future<void> _saveState() async {
    await StorageService.instance.saveData(_stateKey, {
      'category': _categoryId,
      'from': _fromId,
      'to': _toId,
      'input': _input,
    });
  }

  Future<void> _rollWeek() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final key = '${start.year}-${start.month}-${start.day}';
    final saved = await StorageService.instance.getString(_weekStartKey);
    if (saved != key) {
      _weekConverts = 0;
      await StorageService.instance.saveString(_weekStartKey, key);
      await StorageService.instance.saveInt(_weekKey, 0);
    }
  }

  Future<void> _touchStreak() async {
    await _rollWeek();
    _weekConverts += 1;
    await StorageService.instance.saveInt(_weekKey, _weekConverts);
    final today = DateTime.now();
    final day = '${today.year}-${today.month}-${today.day}';
    final last = await StorageService.instance.getString(_lastDayKey);
    if (last == day) return;
    final yesterday = today.subtract(const Duration(days: 1));
    final y = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
    _streak = last == y ? _streak + 1 : 1;
    await StorageService.instance.saveString(_lastDayKey, day);
    await StorageService.instance.saveInt(_streakKey, _streak);
  }
}
