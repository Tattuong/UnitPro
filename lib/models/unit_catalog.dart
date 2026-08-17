import 'package:flutter/material.dart';

enum UnitKind { factor, temperature }

class MeasureUnit {
  final String id;
  final String name;
  final String symbol;
  final double toBase;
  final UnitKind kind;

  const MeasureUnit({
    required this.id,
    required this.name,
    required this.symbol,
    this.toBase = 1,
    this.kind = UnitKind.factor,
  });

  String get label => '$name ($symbol)';
}

class UnitCategory {
  final String id;
  final String titleKey;
  final IconData icon;
  final bool premium;
  final List<MeasureUnit> units;
  final List<String> quickIds;

  const UnitCategory({
    required this.id,
    required this.titleKey,
    required this.icon,
    required this.units,
    required this.quickIds,
    this.premium = false,
  });

  MeasureUnit unit(String id) => units.firstWhere((u) => u.id == id, orElse: () => units.first);
}

class UnitCatalog {
  UnitCatalog._();

  static const length = UnitCategory(
    id: 'length',
    titleKey: 'catLength',
    icon: Icons.straighten_rounded,
    quickIds: ['m', 'cm', 'mm', 'mi', 'yd', 'ft'],
    units: [
      MeasureUnit(id: 'km', name: 'Kilometer', symbol: 'km', toBase: 1000),
      MeasureUnit(id: 'm', name: 'Meter', symbol: 'm', toBase: 1),
      MeasureUnit(id: 'cm', name: 'Centimeter', symbol: 'cm', toBase: 0.01),
      MeasureUnit(id: 'mm', name: 'Millimeter', symbol: 'mm', toBase: 0.001),
      MeasureUnit(id: 'mi', name: 'Mile', symbol: 'mi', toBase: 1609.344),
      MeasureUnit(id: 'yd', name: 'Yard', symbol: 'yd', toBase: 0.9144),
      MeasureUnit(id: 'ft', name: 'Foot', symbol: 'ft', toBase: 0.3048),
      MeasureUnit(id: 'in', name: 'Inch', symbol: 'in', toBase: 0.0254),
      MeasureUnit(id: 'nmi', name: 'Nautical mile', symbol: 'nmi', toBase: 1852),
    ],
  );

  static const weight = UnitCategory(
    id: 'weight',
    titleKey: 'catWeight',
    icon: Icons.monitor_weight_outlined,
    quickIds: ['kg', 'g', 'mg', 'lb', 'oz', 't'],
    units: [
      MeasureUnit(id: 't', name: 'Tonne', symbol: 't', toBase: 1000),
      MeasureUnit(id: 'kg', name: 'Kilogram', symbol: 'kg', toBase: 1),
      MeasureUnit(id: 'g', name: 'Gram', symbol: 'g', toBase: 0.001),
      MeasureUnit(id: 'mg', name: 'Milligram', symbol: 'mg', toBase: 0.000001),
      MeasureUnit(id: 'lb', name: 'Pound', symbol: 'lb', toBase: 0.45359237),
      MeasureUnit(id: 'oz', name: 'Ounce', symbol: 'oz', toBase: 0.028349523125),
      MeasureUnit(id: 'st', name: 'Stone', symbol: 'st', toBase: 6.35029318),
    ],
  );

  static const temperature = UnitCategory(
    id: 'temperature',
    titleKey: 'catTemperature',
    icon: Icons.thermostat_rounded,
    quickIds: ['c', 'f', 'k'],
    units: [
      MeasureUnit(id: 'c', name: 'Celsius', symbol: '°C', kind: UnitKind.temperature),
      MeasureUnit(id: 'f', name: 'Fahrenheit', symbol: '°F', kind: UnitKind.temperature),
      MeasureUnit(id: 'k', name: 'Kelvin', symbol: 'K', kind: UnitKind.temperature),
    ],
  );

  static const area = UnitCategory(
    id: 'area',
    titleKey: 'catArea',
    icon: Icons.crop_square_outlined,
    quickIds: ['m2', 'km2', 'ha', 'acre', 'ft2', 'yd2'],
    units: [
      MeasureUnit(id: 'km2', name: 'Square kilometer', symbol: 'km²', toBase: 1e6),
      MeasureUnit(id: 'ha', name: 'Hectare', symbol: 'ha', toBase: 10000),
      MeasureUnit(id: 'm2', name: 'Square meter', symbol: 'm²', toBase: 1),
      MeasureUnit(id: 'acre', name: 'Acre', symbol: 'ac', toBase: 4046.8564224),
      MeasureUnit(id: 'yd2', name: 'Square yard', symbol: 'yd²', toBase: 0.83612736),
      MeasureUnit(id: 'ft2', name: 'Square foot', symbol: 'ft²', toBase: 0.09290304),
      MeasureUnit(id: 'in2', name: 'Square inch', symbol: 'in²', toBase: 0.00064516),
    ],
  );

  static const volume = UnitCategory(
    id: 'volume',
    titleKey: 'catVolume',
    icon: Icons.water_drop_outlined,
    premium: true,
    quickIds: ['l', 'ml', 'gal', 'qt', 'cup', 'floz'],
    units: [
      MeasureUnit(id: 'm3', name: 'Cubic meter', symbol: 'm³', toBase: 1000),
      MeasureUnit(id: 'l', name: 'Liter', symbol: 'L', toBase: 1),
      MeasureUnit(id: 'ml', name: 'Milliliter', symbol: 'mL', toBase: 0.001),
      MeasureUnit(id: 'gal', name: 'US gallon', symbol: 'gal', toBase: 3.785411784),
      MeasureUnit(id: 'qt', name: 'US quart', symbol: 'qt', toBase: 0.946352946),
      MeasureUnit(id: 'cup', name: 'Cup', symbol: 'cup', toBase: 0.2365882365),
      MeasureUnit(id: 'floz', name: 'Fluid ounce', symbol: 'fl oz', toBase: 0.0295735295625),
    ],
  );

  static const speed = UnitCategory(
    id: 'speed',
    titleKey: 'catSpeed',
    icon: Icons.speed_rounded,
    premium: true,
    quickIds: ['kmh', 'mph', 'ms', 'kn', 'fts'],
    units: [
      MeasureUnit(id: 'ms', name: 'Meter/second', symbol: 'm/s', toBase: 1),
      MeasureUnit(id: 'kmh', name: 'Kilometer/hour', symbol: 'km/h', toBase: 1 / 3.6),
      MeasureUnit(id: 'mph', name: 'Mile/hour', symbol: 'mph', toBase: 0.44704),
      MeasureUnit(id: 'kn', name: 'Knot', symbol: 'kn', toBase: 0.514444),
      MeasureUnit(id: 'fts', name: 'Foot/second', symbol: 'ft/s', toBase: 0.3048),
    ],
  );

  static const time = UnitCategory(
    id: 'time',
    titleKey: 'catTime',
    icon: Icons.schedule_rounded,
    premium: true,
    quickIds: ['s', 'min', 'h', 'd', 'wk'],
    units: [
      MeasureUnit(id: 'ms', name: 'Millisecond', symbol: 'ms', toBase: 0.001),
      MeasureUnit(id: 's', name: 'Second', symbol: 's', toBase: 1),
      MeasureUnit(id: 'min', name: 'Minute', symbol: 'min', toBase: 60),
      MeasureUnit(id: 'h', name: 'Hour', symbol: 'h', toBase: 3600),
      MeasureUnit(id: 'd', name: 'Day', symbol: 'd', toBase: 86400),
      MeasureUnit(id: 'wk', name: 'Week', symbol: 'wk', toBase: 604800),
    ],
  );

  static const data = UnitCategory(
    id: 'data',
    titleKey: 'catData',
    icon: Icons.memory_rounded,
    premium: true,
    quickIds: ['b', 'kb', 'mb', 'gb', 'tb'],
    units: [
      MeasureUnit(id: 'b', name: 'Byte', symbol: 'B', toBase: 1),
      MeasureUnit(id: 'kb', name: 'Kilobyte', symbol: 'KB', toBase: 1000),
      MeasureUnit(id: 'mb', name: 'Megabyte', symbol: 'MB', toBase: 1e6),
      MeasureUnit(id: 'gb', name: 'Gigabyte', symbol: 'GB', toBase: 1e9),
      MeasureUnit(id: 'tb', name: 'Terabyte', symbol: 'TB', toBase: 1e12),
    ],
  );

  static const List<UnitCategory> all = [length, weight, temperature, area, volume, speed, time, data];

  static UnitCategory get(String id) => all.firstWhere((c) => c.id == id, orElse: () => length);

  static double toBase(MeasureUnit unit, double value) {
    if (unit.kind == UnitKind.temperature) {
      return switch (unit.id) {
        'f' => (value - 32) * 5 / 9,
        'k' => value - 273.15,
        _ => value,
      };
    }
    return value * unit.toBase;
  }

  static double fromBase(MeasureUnit unit, double base) {
    if (unit.kind == UnitKind.temperature) {
      return switch (unit.id) {
        'f' => base * 9 / 5 + 32,
        'k' => base + 273.15,
        _ => base,
      };
    }
    return base / unit.toBase;
  }

  static double convert({required MeasureUnit from, required MeasureUnit to, required double value}) {
    return fromBase(to, toBase(from, value));
  }

  static String format(double value, {int decimals = 6}) {
    if (value.isNaN || value.isInfinite) return '—';
    if (value == 0) return '0';
    final abs = value.abs();
    if (abs >= 1e9 || (abs < 1e-4 && abs > 0)) {
      return value.toStringAsExponential(4);
    }
    var text = value.toStringAsFixed(decimals);
    if (text.contains('.')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      if (text.endsWith('.')) text = text.substring(0, text.length - 1);
    }
    return text;
  }
}

class ConversionPair {
  final String categoryId;
  final String fromId;
  final String toId;

  const ConversionPair({required this.categoryId, required this.fromId, required this.toId});

  String get key => '$categoryId|$fromId|$toId';

  factory ConversionPair.decode(String raw) {
    final p = raw.split('|');
    if (p.length != 3) return const ConversionPair(categoryId: 'length', fromId: 'km', toId: 'mi');
    return ConversionPair(categoryId: p[0], fromId: p[1], toId: p[2]);
  }
}

class ConversionRecord {
  final ConversionPair pair;
  final String input;
  final String output;
  final int atMs;

  const ConversionRecord({required this.pair, required this.input, required this.output, required this.atMs});

  Map<String, dynamic> toJson() => {
        'pair': pair.key,
        'input': input,
        'output': output,
        'at': atMs,
      };

  factory ConversionRecord.fromJson(Map<String, dynamic> json) => ConversionRecord(
        pair: ConversionPair.decode(json['pair']?.toString() ?? ''),
        input: json['input']?.toString() ?? '',
        output: json['output']?.toString() ?? '',
        atMs: json['at'] is int ? json['at'] as int : int.tryParse('${json['at']}') ?? 0,
      );
}
