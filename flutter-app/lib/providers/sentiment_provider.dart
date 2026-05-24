import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/remote/api_client.dart';
import '../core/end_points.dart';
import '../core/remote/data/sentiment/sentiment_models.dart';

// ── Selected coin for coin-signals tab ────────────────────────────────────────

final sentimentCoinIdProvider =
    StateProvider<String>((ref) => 'bitcoin');

// ── News ──────────────────────────────────────────────────────────────────────

final sentimentNewsProvider =
    FutureProvider.autoDispose<List<SentimentNewsItem>>((ref) async {
  final api = ApiClient.instance;
  final res = await api.get<dynamic>(EndPoints.sentimentNews);
  final body = res.data;

  List<dynamic> list = const [];

  if (body is List) {
    list = body;
  } else if (body is Map<String, dynamic>) {
    final inner =
        body['data'] ?? body['news'] ?? body['articles'] ?? body['items'];
    if (inner is List) {
      list = inner;
    } else if (inner is Map<String, dynamic>) {
      final deep = inner['articles'] ??
          inner['news'] ??
          inner['items'] ??
          inner['data'] ??
          [];
      if (deep is List) list = deep;
    }
  }

  return list
      .whereType<Map>()
      .map((m) => SentimentNewsItem.fromJson(Map<String, dynamic>.from(m)))
      .toList();
});

// ── Social ────────────────────────────────────────────────────────────────────

final sentimentSocialProvider =
    FutureProvider.autoDispose<SocialSentimentData>((ref) async {
  final api = ApiClient.instance;
  final res =
      await api.get<Map<String, dynamic>>(EndPoints.sentimentSocial);
  final raw = res.data ?? {};
  final inner = raw['data'];
  final payload = inner is Map<String, dynamic> ? inner : raw;
  return SocialSentimentData.fromJson(payload);
});

// ── Coin signals ──────────────────────────────────────────────────────────────

final coinSentimentProvider =
    FutureProvider.autoDispose.family<CoinSentimentData, String>(
        (ref, coinId) async {
  final api = ApiClient.instance;
  final res = await api
      .get<Map<String, dynamic>>(EndPoints.sentimentCoin(coinId));
  final raw = res.data ?? {};
  final inner = raw['data'];
  final payload = inner is Map<String, dynamic> ? inner : raw;
  return CoinSentimentData.fromJson(payload);
});

// ── On-Chain ──────────────────────────────────────────────────────────────────

final onChainSentimentProvider =
    FutureProvider.autoDispose<OnChainSentimentData>((ref) async {
  final api = ApiClient.instance;
  final res =
      await api.get<Map<String, dynamic>>(EndPoints.sentimentOnChain);
  final raw = res.data ?? {};
  final inner = raw['data'];
  final payload = inner is Map<String, dynamic> ? inner : raw;
  return OnChainSentimentData.fromJson(payload);
});
