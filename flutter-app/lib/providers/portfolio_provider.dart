import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/remote/api_client.dart';
import '../core/end_points.dart';

// ── Color lookup ───────────────────────────────────────────────────────────────

const _symbolColors = <String, Color>{
  'BTC': Color(0xFFF7931A),
  'ETH': Color(0xFF627EEA),
  'SOL': Color(0xFF9945FF),
  'BNB': Color(0xFFF3BA2F),
  'XRP': Color(0xFF346AA9),
  'ADA': Color(0xFF0033AD),
  'DOGE': Color(0xFFBA9F33),
  'ARB': Color(0xFF12AAFF),
  'OP': Color(0xFFFF0420),
};

Color _colorFor(String symbol, int index) {
  final key = symbol.toUpperCase().replaceAll('USDT', '');
  if (_symbolColors.containsKey(key)) return _symbolColors[key]!;
  const fallbacks = [
    Color(0xFF00FF88), Color(0xFF4FC3F7), Color(0xFFCE93D8),
    Color(0xFFFFD54F), Color(0xFF80CBC4),
  ];
  return fallbacks[index % fallbacks.length];
}

// ── Models ─────────────────────────────────────────────────────────────────────

class PortfolioHolding {
  final String symbol;
  final String name;
  final String? coinId;
  final String? imageUrl;
  final double amount;
  final double avgBuy;
  final double currentPrice;
  final Color color;

  const PortfolioHolding({
    required this.symbol,
    required this.name,
    this.coinId,
    this.imageUrl,
    required this.amount,
    required this.avgBuy,
    required this.currentPrice,
    required this.color,
  });

  double get value => amount * currentPrice;
  double get pnl => (currentPrice - avgBuy) * amount;
  double get pnlPct =>
      avgBuy > 0 ? ((currentPrice - avgBuy) / avgBuy) * 100 : 0;
  bool get positive => pnl >= 0;

  factory PortfolioHolding.fromJson(Map<String, dynamic> j, int index) {
    final sym = j['symbol']?.toString() ?? j['asset']?.toString() ?? '';
    final avgBuy = (j['avgBuyPrice'] as num?)?.toDouble() ??
        (j['avg_buy_price'] as num?)?.toDouble() ??
        (j['averagePrice'] as num?)?.toDouble() ??
        0.0;
    final current = (j['currentPrice'] as num?)?.toDouble() ??
        (j['current_price'] as num?)?.toDouble() ??
        (j['price'] as num?)?.toDouble() ??
        avgBuy;
    final amount = (j['amount'] as num?)?.toDouble() ??
        (j['quantity'] as num?)?.toDouble() ??
        (j['balance'] as num?)?.toDouble() ??
        0.0;
    return PortfolioHolding(
      symbol: sym,
      name: j['name']?.toString() ?? sym,
      coinId: j['coinId']?.toString() ?? j['coin_id']?.toString(),
      imageUrl: j['imageUrl']?.toString() ?? j['image']?.toString(),
      amount: amount,
      avgBuy: avgBuy,
      currentPrice: current,
      color: _colorFor(sym, index),
    );
  }
}

class EquityPoint {
  final DateTime date;
  final double value;
  const EquityPoint({required this.date, required this.value});

  factory EquityPoint.fromJson(Map<String, dynamic> j) {
    DateTime? dt;
    try {
      dt = DateTime.parse(
          j['date']?.toString() ?? j['timestamp']?.toString() ?? '');
    } catch (_) {}
    return EquityPoint(
      date: dt ?? DateTime.now(),
      value: (j['value'] as num?)?.toDouble() ??
          (j['equity'] as num?)?.toDouble() ??
          0,
    );
  }
}

class PortfolioData {
  final List<PortfolioHolding> holdings;
  final double totalValue;
  final double totalPnl;
  final double totalPnlPct;
  final List<EquityPoint> equityCurve;

  const PortfolioData({
    required this.holdings,
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.equityCurve,
  });

  bool get isEmpty => holdings.isEmpty;

  factory PortfolioData.empty() => const PortfolioData(
        holdings: [],
        totalValue: 0,
        totalPnl: 0,
        totalPnlPct: 0,
        equityCurve: [],
      );
}

// ── Repository ─────────────────────────────────────────────────────────────────

Future<Map<String, dynamic>?> _safeFetch(
    Future<dynamic> Function() call) async {
  try {
    final res = await call();
    return res?.data as Map<String, dynamic>?;
  } catch (_) {
    return null;
  }
}

Future<PortfolioData> fetchPortfolioData() async {
  final api = ApiClient.instance;

  final holdingsBody = await _safeFetch(
    () => api.get<Map<String, dynamic>>(EndPoints.portfolioHoldings),
  );
  final perfBody = await _safeFetch(
    () => api.get<Map<String, dynamic>>(EndPoints.portfolioPerformance),
  );

  // ── Parse holdings ─────────────────────────────────────────────────────────
  List<PortfolioHolding> holdings = [];
  if (holdingsBody != null) {
    final raw =
        holdingsBody['data'] ?? holdingsBody['holdings'] ?? holdingsBody;
    final list = raw is List
        ? raw
        : raw is Map
            ? (raw['holdings'] ?? raw['items'] ?? [])
            : [];
    if (list is List) {
      holdings = list
          .whereType<Map<String, dynamic>>()
          .toList()
          .asMap()
          .entries
          .map((e) => PortfolioHolding.fromJson(e.value, e.key))
          .toList();
    }
  }

  // ── Parse performance ──────────────────────────────────────────────────────
  double totalValue = holdings.fold(0.0, (s, h) => s + h.value);
  double totalPnl = holdings.fold(0.0, (s, h) => s + h.pnl);
  double totalPnlPct = (totalValue - totalPnl) > 0
      ? (totalPnl / (totalValue - totalPnl)) * 100
      : 0;
  List<EquityPoint> equityCurve = [];

  if (perfBody != null) {
    final raw = perfBody['data'] ?? perfBody;
    if (raw is Map<String, dynamic>) {
      totalValue = (raw['totalValue'] as num?)?.toDouble() ?? totalValue;
      totalPnl = (raw['totalPnl'] as num?)?.toDouble() ?? totalPnl;
      totalPnlPct = (raw['totalPnlPercent'] as num?)?.toDouble() ??
          (raw['totalPnlPct'] as num?)?.toDouble() ??
          totalPnlPct;
      final curve =
          raw['equityCurve'] ?? raw['equity_curve'] ?? raw['history'];
      if (curve is List) {
        equityCurve = curve
            .whereType<Map<String, dynamic>>()
            .map(EquityPoint.fromJson)
            .toList();
      }
    }
  }

  return PortfolioData(
    holdings: holdings,
    totalValue: totalValue,
    totalPnl: totalPnl,
    totalPnlPct: totalPnlPct,
    equityCurve: equityCurve,
  );
}

// ── Provider ───────────────────────────────────────────────────────────────────

final portfolioProvider =
    FutureProvider.autoDispose<PortfolioData>((_) => fetchPortfolioData());
