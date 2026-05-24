double _n(dynamic v) => (v as num?)?.toDouble() ?? 0.0;
double? _nOpt(dynamic v) => v == null ? null : (v as num?)?.toDouble();
DateTime? _date(dynamic v) {
  if (v == null) return null;
  try {
    return DateTime.parse(v.toString());
  } catch (_) {
    return null;
  }
}

// ── News ──────────────────────────────────────────────────────────────────────

class SentimentNewsItem {
  final String id;
  final String title;
  final String? description;
  final String? url;
  final String source;
  final String sentiment; // bullish | bearish | neutral
  final double? sentimentScore;
  final DateTime? publishedAt;

  const SentimentNewsItem({
    required this.id,
    required this.title,
    this.description,
    this.url,
    required this.source,
    required this.sentiment,
    this.sentimentScore,
    this.publishedAt,
  });

  factory SentimentNewsItem.fromJson(Map<String, dynamic> j) =>
      SentimentNewsItem(
        id: j['id']?.toString() ?? j['_id']?.toString() ?? '',
        title: j['title']?.toString() ?? '',
        description:
            j['description']?.toString() ?? j['summary']?.toString(),
        url: j['url']?.toString(),
        source: j['source']?.toString() ??
            j['publisher']?.toString() ??
            'Unknown',
        sentiment: j['sentiment']?.toString() ?? 'neutral',
        sentimentScore:
            _nOpt(j['sentimentScore'] ?? j['score'] ?? j['aiScore']),
        publishedAt: _date(
            j['publishedAt'] ?? j['published_at'] ?? j['createdAt']),
      );
}

// ── Social ────────────────────────────────────────────────────────────────────

class SocialPost {
  final String author;
  final String content;
  final String platform; // twitter | reddit
  final String? sentiment;
  final DateTime? publishedAt;
  final int? likes;
  final int? comments;
  final String? subreddit;

  const SocialPost({
    required this.author,
    required this.content,
    required this.platform,
    this.sentiment,
    this.publishedAt,
    this.likes,
    this.comments,
    this.subreddit,
  });

  factory SocialPost.fromJson(Map<String, dynamic> j) => SocialPost(
        author: j['author']?.toString() ??
            j['username']?.toString() ??
            j['user']?.toString() ??
            'Unknown',
        content: j['content']?.toString() ??
            j['text']?.toString() ??
            j['body']?.toString() ??
            '',
        platform: j['platform']?.toString() ?? 'unknown',
        sentiment: j['sentiment']?.toString(),
        publishedAt:
            _date(j['publishedAt'] ?? j['created_at'] ?? j['timestamp']),
        likes: (j['likes'] ?? j['upvotes'] ?? j['score'] as num?)?.toInt(),
        comments:
            (j['comments'] ?? j['numComments'] as num?)?.toInt(),
        subreddit: j['subreddit']?.toString(),
      );
}

class PlatformSentiment {
  final double bullishPercent;
  final double bearishPercent;
  final double neutralPercent;
  final int totalMentions;
  final double? volumeChange24h;
  final List<SocialPost> posts;

  const PlatformSentiment({
    required this.bullishPercent,
    required this.bearishPercent,
    required this.neutralPercent,
    required this.totalMentions,
    this.volumeChange24h,
    required this.posts,
  });

  factory PlatformSentiment.fromJson(Map<String, dynamic> j) {
    final rawPosts = j['posts'] ?? j['tweets'] ?? j['items'] ?? [];
    return PlatformSentiment(
      bullishPercent:
          _n(j['bullishPercent'] ?? j['bullish_percent'] ?? j['bullish']),
      bearishPercent:
          _n(j['bearishPercent'] ?? j['bearish_percent'] ?? j['bearish']),
      neutralPercent:
          _n(j['neutralPercent'] ?? j['neutral_percent'] ?? j['neutral']),
      totalMentions:
          (j['totalMentions'] ?? j['total_mentions'] ?? j['mentions']
                  as num?)
              ?.toInt() ??
              0,
      volumeChange24h:
          _nOpt(j['volumeChange24h'] ?? j['volume_change']),
      posts: (rawPosts as List)
          .whereType<Map>()
          .map((m) => SocialPost.fromJson(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}

class SocialSentimentData {
  final PlatformSentiment? twitter;
  final PlatformSentiment? reddit;

  const SocialSentimentData({this.twitter, this.reddit});

  double get overallBullish {
    final t = twitter?.bullishPercent ?? 0;
    final r = reddit?.bullishPercent ?? 0;
    if (twitter != null && reddit != null) return (t + r) / 2;
    return t + r;
  }

  factory SocialSentimentData.fromJson(Map<String, dynamic> j) {
    final tRaw = j['twitter'] ?? j['Twitter'];
    final rRaw = j['reddit'] ?? j['Reddit'];
    return SocialSentimentData(
      twitter: tRaw is Map
          ? PlatformSentiment.fromJson(Map<String, dynamic>.from(tRaw))
          : null,
      reddit: rRaw is Map
          ? PlatformSentiment.fromJson(Map<String, dynamic>.from(rRaw))
          : null,
    );
  }
}

// ── Coin Signals ──────────────────────────────────────────────────────────────

class CoinSignal {
  final String type; // social | onchain | news | technical
  final String signal; // bullish | bearish | neutral
  final double? confidence;
  final String? description;

  const CoinSignal({
    required this.type,
    required this.signal,
    this.confidence,
    this.description,
  });

  factory CoinSignal.fromJson(Map<String, dynamic> j) => CoinSignal(
        type: j['type']?.toString() ?? 'general',
        signal: j['signal']?.toString() ?? 'neutral',
        confidence: _nOpt(j['confidence'] ?? j['score']),
        description: j['description']?.toString() ??
            j['message']?.toString(),
      );
}

class CoinSentimentData {
  final String coinId;
  final String symbol;
  final String overallSentiment;
  final double overallScore;
  final List<CoinSignal> signals;

  const CoinSentimentData({
    required this.coinId,
    required this.symbol,
    required this.overallSentiment,
    required this.overallScore,
    required this.signals,
  });

  factory CoinSentimentData.fromJson(Map<String, dynamic> j) {
    final rawSignals = j['signals'] ?? [];
    return CoinSentimentData(
      coinId:
          j['coinId']?.toString() ?? j['coin_id']?.toString() ?? '',
      symbol: j['symbol']?.toString() ?? '',
      overallSentiment: j['overallSentiment']?.toString() ??
          j['sentiment']?.toString() ??
          'neutral',
      overallScore: _n(j['overallScore'] ?? j['score'] ?? j['sentimentScore']),
      signals: (rawSignals as List)
          .whereType<Map>()
          .map((m) => CoinSignal.fromJson(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}

// ── On-Chain ──────────────────────────────────────────────────────────────────

class OnChainIndicator {
  final String name;
  final String value;
  final String signal;
  final String description;

  const OnChainIndicator({
    required this.name,
    required this.value,
    required this.signal,
    required this.description,
  });

  factory OnChainIndicator.fromJson(Map<String, dynamic> j) =>
      OnChainIndicator(
        name: j['name']?.toString() ?? '',
        value: j['value']?.toString() ?? '—',
        signal: j['signal']?.toString() ?? 'Neutral',
        description: j['description']?.toString() ??
            j['explanation']?.toString() ??
            '',
      );
}

class ExchangeFlows {
  final double inflow;
  final double outflow;
  final double netFlow;
  final double? reserve;

  const ExchangeFlows({
    required this.inflow,
    required this.outflow,
    required this.netFlow,
    this.reserve,
  });

  factory ExchangeFlows.fromJson(Map<String, dynamic> j) =>
      ExchangeFlows(
        inflow: _n(j['inflow'] ?? j['exchangeInflow']),
        outflow: _n(j['outflow'] ?? j['exchangeOutflow']),
        netFlow: _n(j['netFlow'] ?? j['net_flow']),
        reserve: _nOpt(j['reserve'] ?? j['exchangeReserve']),
      );
}

class OnChainSentimentData {
  final List<OnChainIndicator> indicators;
  final ExchangeFlows? flows;
  final String? aiSummary;

  const OnChainSentimentData({
    required this.indicators,
    this.flows,
    this.aiSummary,
  });

  factory OnChainSentimentData.fromJson(Map<String, dynamic> j) {
    final rawInd = j['indicators'] ?? j['metrics'] ?? [];
    final rawFlows = j['exchangeFlows'] ?? j['flows'];
    return OnChainSentimentData(
      indicators: (rawInd as List)
          .whereType<Map>()
          .map((m) =>
              OnChainIndicator.fromJson(Map<String, dynamic>.from(m)))
          .toList(),
      flows: rawFlows is Map
          ? ExchangeFlows.fromJson(Map<String, dynamic>.from(rawFlows))
          : null,
      aiSummary:
          j['aiSummary']?.toString() ?? j['summary']?.toString(),
    );
  }
}
