import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/remote/api_client.dart';
import '../core/end_points.dart';

class OnchainIndicator {
  final String name;
  final double value;
  final String signal;
  final String level; // bullish | neutral | bearish
  final String description;

  const OnchainIndicator({
    required this.name,
    required this.value,
    required this.signal,
    required this.level,
    required this.description,
  });

  factory OnchainIndicator.fromJson(Map<String, dynamic> j) => OnchainIndicator(
    name: (j['name'] ?? '').toString(),
    value: (j['value'] as num?)?.toDouble() ?? 0,
    signal: (j['signal'] ?? '').toString(),
    level: (j['level'] ?? 'neutral').toString().toLowerCase(),
    description: (j['description'] ?? '').toString(),
  );
}

final onchainIndicatorsProvider =
    FutureProvider.autoDispose.family<List<OnchainIndicator>, String>((ref, symbol) async {
  try {
    final res = await ApiClient.instance.get<dynamic>(
      EndPoints.onchainIndicatorsWithParams(symbol: symbol),
    );
    final body = res.data;
    if (body == null) return [];
    final data = (body is Map) ? (body['data'] ?? body) : body;
    if (data is! Map) return [];
    final list = data['indicators'];
    if (list is! List) return [];
    return list.whereType<Map<String, dynamic>>().map(OnchainIndicator.fromJson).toList();
  } catch (_) {
    return [];
  }
});
