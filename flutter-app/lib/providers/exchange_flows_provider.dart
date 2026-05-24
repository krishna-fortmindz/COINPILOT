import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/remote/api_client.dart';
import '../core/end_points.dart';

// ─────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────

class ExchangeBreakdown {
  final String exchange;
  final double inflow;
  final double outflow;
  final double netflow;

  const ExchangeBreakdown({
    required this.exchange,
    required this.inflow,
    required this.outflow,
    required this.netflow,
  });

  factory ExchangeBreakdown.fromJson(Map<String, dynamic> j) => ExchangeBreakdown(
    exchange: (j['exchange'] ?? j['name'] ?? 'Unknown').toString(),
    inflow: (j['inflow'] as num?)?.toDouble() ?? 0,
    outflow: (j['outflow'] as num?)?.toDouble() ?? 0,
    netflow: (j['netflow'] as num?)?.toDouble() ?? (j['net'] as num?)?.toDouble() ?? 0,
  );
}

class ExchangeFlowsSummary {
  final double totalInflow;
  final double totalOutflow;
  final double netflow;
  final String symbol;
  final int? days;
  final List<ExchangeBreakdown> exchangeBreakdown;

  const ExchangeFlowsSummary({
    required this.totalInflow,
    required this.totalOutflow,
    required this.netflow,
    required this.symbol,
    this.days,
    this.exchangeBreakdown = const [],
  });

  bool get isBullish => netflow < 0; // more outflow = bullish

  factory ExchangeFlowsSummary.fromJson(Map<String, dynamic> j) {
    // Backend: { symbol, days, inflow, outflow, netflow, exchangeBreakdown: [...] }
    final totalIn = (j['inflow'] as num?)?.toDouble() ??
        (j['totalInflow'] as num?)?.toDouble() ?? 0;
    final totalOut = (j['outflow'] as num?)?.toDouble() ??
        (j['totalOutflow'] as num?)?.toDouble() ?? 0;
    final netflow = (j['netflow'] as num?)?.toDouble() ??
        (j['net'] as num?)?.toDouble() ?? (totalOut - totalIn);

    final rawBreakdown = j['exchangeBreakdown'] ?? j['exchanges'] ?? j['breakdown'] ?? [];
    final breakdown = (rawBreakdown is List)
        ? rawBreakdown.whereType<Map<String, dynamic>>().map(ExchangeBreakdown.fromJson).toList()
        : <ExchangeBreakdown>[];

    return ExchangeFlowsSummary(
      totalInflow: totalIn,
      totalOutflow: totalOut,
      netflow: netflow,
      symbol: (j['symbol'] ?? 'BTC').toString(),
      days: (j['days'] as num?)?.toInt(),
      exchangeBreakdown: breakdown,
    );
  }

  static ExchangeFlowsSummary empty(String symbol) => ExchangeFlowsSummary(
    totalInflow: 0,
    totalOutflow: 0,
    netflow: 0,
    symbol: symbol,
  );
}

class TopExchange {
  final String name;
  final double inflow;
  final double outflow;
  final double netflow;

  const TopExchange({
    required this.name,
    required this.inflow,
    required this.outflow,
    required this.netflow,
  });

  bool get isNetInflow => netflow > 0;

  factory TopExchange.fromJson(Map<String, dynamic> j) => TopExchange(
    // Backend key is 'exchange', not 'name'
    name: (j['exchange'] ?? j['name'] ?? j['exchangeName'] ?? 'Unknown').toString(),
    // Backend uses 'inflow24h'/'outflow24h'/'netflow24h' for the top-exchanges endpoint
    inflow: (j['inflow24h'] as num?)?.toDouble() ?? (j['inflow'] as num?)?.toDouble() ?? 0,
    outflow: (j['outflow24h'] as num?)?.toDouble() ?? (j['outflow'] as num?)?.toDouble() ?? 0,
    netflow: (j['netflow24h'] as num?)?.toDouble() ??
        (j['netflow'] as num?)?.toDouble() ??
        (j['net'] as num?)?.toDouble() ?? 0,
  );
}

// ─────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────

final exchangeFlowsNetflowProvider =
    FutureProvider.autoDispose.family<ExchangeFlowsSummary, String>((ref, symbol) async {
  try {
    final url = EndPoints.exchangeFlowsNetflowWithParams(symbol: symbol, days: 30);
    final res = await ApiClient.instance.get<dynamic>(url);
    final body = res.data;
    if (body == null) return ExchangeFlowsSummary.empty(symbol);
    Map<String, dynamic> json;
    if (body is Map<String, dynamic>) {
      final inner = body['data'];
      json = (inner is Map<String, dynamic>) ? inner : body;
    } else {
      return ExchangeFlowsSummary.empty(symbol);
    }
    return ExchangeFlowsSummary.fromJson(json);
  } catch (_) {
    return ExchangeFlowsSummary.empty(symbol);
  }
});

final topExchangesProvider = FutureProvider.autoDispose<List<TopExchange>>((ref) async {
  try {
    final url = EndPoints.exchangeFlowsTopExchangesWithParams(limit: 10);
    final res = await ApiClient.instance.get<dynamic>(url);
    final body = res.data;
    List<dynamic> list = const [];
    if (body is List) {
      list = body;
    } else if (body is Map) {
      // Backend: { data: [...] }
      final inner = body['data'] ?? body['exchanges'] ?? body['results'];
      if (inner is List) list = inner;
    }
    return list.whereType<Map<String, dynamic>>().map(TopExchange.fromJson).toList();
  } catch (_) {
    return [];
  }
});
