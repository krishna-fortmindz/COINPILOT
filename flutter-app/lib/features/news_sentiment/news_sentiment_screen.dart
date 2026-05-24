import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/remote/data/sentiment/sentiment_models.dart';
import '../../providers/sentiment_provider.dart';

// ── Main Screen ───────────────────────────────────────────────────────────────

class NewsSentimentScreen extends ConsumerStatefulWidget {
  const NewsSentimentScreen({super.key});

  @override
  ConsumerState<NewsSentimentScreen> createState() =>
      _NewsSentimentScreenState();
}

class _NewsSentimentScreenState
    extends ConsumerState<NewsSentimentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final social = ref.watch(sentimentSocialProvider);
    final overallScore =
        social.valueOrNull?.overallBullish.round() ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        children: [
          _Header(tabController: _tabs, sentimentScore: overallScore),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: const [
                _NewsTab(),
                _SocialTab(),
                _CoinSignalsTab(),
                _OnChainTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final TabController tabController;
  final int sentimentScore;
  const _Header(
      {required this.tabController, required this.sentimentScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('News & Sentiment',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    Text('Real-time market sentiment aggregation',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              _SentimentMeter(value: sentimentScore),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.brandGreen,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w400),
            indicatorColor: AppColors.brandGreen,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'News'),
              Tab(text: 'Social'),
              Tab(text: 'Coin Signals'),
              Tab(text: 'On-Chain'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentimentMeter extends StatelessWidget {
  final int value;
  const _SentimentMeter({required this.value});

  @override
  Widget build(BuildContext context) {
    final color = value > 60
        ? AppColors.brandGreen
        : value > 45
            ? AppColors.brandAmber
            : value == 0
                ? AppColors.textMuted
                : AppColors.brandRed;
    final label = value > 60
        ? 'Bullish'
        : value > 45
            ? 'Neutral'
            : value == 0
                ? '—'
                : 'Bearish';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value > 0 ? '$value' : '—',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: color,
                  fontFamily: 'JetBrainsMono')),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color)),
              const Text('Sentiment',
                  style: TextStyle(
                      fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── News Tab ──────────────────────────────────────────────────────────────────

class _NewsTab extends ConsumerWidget {
  const _NewsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(sentimentNewsProvider);
    return news.when(
      loading: () => const _LoadingView(),
      error: (e, _) => _ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(sentimentNewsProvider),
      ),
      data: (items) => items.isEmpty
          ? const _EmptyView(message: 'No news available')
          : RefreshIndicator(
              color: AppColors.brandGreen,
              backgroundColor: AppColors.bgSecondary,
              onRefresh: () async => ref.invalidate(sentimentNewsProvider),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _NewsCard(item: items[i]),
              ),
            ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final SentimentNewsItem item;
  const _NewsCard({required this.item});

  Color _sentimentColor(String s) {
    switch (s.toLowerCase()) {
      case 'bullish':
        return AppColors.brandGreen;
      case 'bearish':
        return AppColors.brandRed;
      default:
        return AppColors.brandAmber;
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = _sentimentColor(item.sentiment);
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 54,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.4)),
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(item.description!,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    _SentimentBadge(
                        label: item.sentiment, color: color),
                    const SizedBox(width: 8),
                    if (item.sentimentScore != null)
                      Text(
                          '${(item.sentimentScore! * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontFamily: 'JetBrainsMono')),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(item.source,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textMuted)),
                    ),
                    const Spacer(),
                    Text(_timeAgo(item.publishedAt),
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textDisabled)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Social Tab ────────────────────────────────────────────────────────────────

class _SocialTab extends ConsumerWidget {
  const _SocialTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final social = ref.watch(sentimentSocialProvider);
    return social.when(
      loading: () => const _LoadingView(),
      error: (e, _) => _ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(sentimentSocialProvider),
      ),
      data: (data) => RefreshIndicator(
        color: AppColors.brandGreen,
        backgroundColor: AppColors.bgSecondary,
        onRefresh: () async => ref.invalidate(sentimentSocialProvider),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (data.twitter != null) ...[
              _PlatformSection(
                platform: 'Twitter / X',
                icon: Icons.tag_rounded,
                color: AppColors.brandBlue,
                data: data.twitter!,
              ),
              const SizedBox(height: 16),
            ],
            if (data.reddit != null) ...[
              _PlatformSection(
                platform: 'Reddit',
                icon: Icons.forum_rounded,
                color: AppColors.brandRed,
                data: data.reddit!,
              ),
            ],
            if (data.twitter == null && data.reddit == null)
              const _EmptyView(message: 'No social data available'),
          ],
        ),
      ),
    );
  }
}

class _PlatformSection extends StatelessWidget {
  final String platform;
  final IconData icon;
  final Color color;
  final PlatformSentiment data;

  const _PlatformSection({
    required this.platform,
    required this.icon,
    required this.color,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final change = data.volumeChange24h;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats header card
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 8),
                  Text(platform,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const Spacer(),
                  if (change != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.brandAmber.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                          '${change >= 0 ? '+' : ''}${change.toStringAsFixed(0)}% vol',
                          style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.brandAmber,
                              fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _SocialMetric(
                    '${data.bullishPercent.toStringAsFixed(0)}%',
                    'Bullish',
                    AppColors.brandGreen,
                  ),
                  const SizedBox(width: 10),
                  _SocialMetric(
                    _formatMentions(data.totalMentions),
                    'Mentions',
                    AppColors.brandBlue,
                  ),
                  const SizedBox(width: 10),
                  _SocialMetric(
                    '${data.bearishPercent.toStringAsFixed(0)}%',
                    'Bearish',
                    AppColors.brandRed,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Sentiment bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    Expanded(
                      flex: data.bullishPercent.round(),
                      child: Container(
                          height: 6,
                          color: AppColors.brandGreen),
                    ),
                    Expanded(
                      flex: data.neutralPercent.round(),
                      child: Container(
                          height: 6,
                          color: AppColors.brandAmber),
                    ),
                    Expanded(
                      flex: data.bearishPercent.round().clamp(1, 100),
                      child: Container(
                          height: 6,
                          color: AppColors.brandRed),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Posts
        if (data.posts.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...data.posts.take(5).map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SocialPostCard(post: p, platformColor: color),
              )),
        ],
      ],
    );
  }

  String _formatMentions(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _SocialMetric extends StatelessWidget {
  final String value, label;
  final Color color;
  const _SocialMetric(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(25)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontFamily: 'JetBrainsMono')),
            Text(label,
                style: const TextStyle(
                    fontSize: 9, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _SocialPostCard extends StatelessWidget {
  final SocialPost post;
  final Color platformColor;
  const _SocialPostCard(
      {required this.post, required this.platformColor});

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final sentiment = post.sentiment ?? 'neutral';
    final sentColor = sentiment == 'bullish'
        ? AppColors.brandGreen
        : sentiment == 'bearish'
            ? AppColors.brandRed
            : AppColors.brandAmber;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: platformColor.withAlpha(20),
                child: Text(
                  post.author.isNotEmpty
                      ? post.author[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: platformColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.subreddit != null
                      ? 'r/${post.subreddit} · @${post.author}'
                      : '@${post.author}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(_timeAgo(post.publishedAt),
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textDisabled)),
            ],
          ),
          const SizedBox(height: 8),
          Text(post.content,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          if (post.likes != null || post.comments != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (post.likes != null) ...[
                  const Icon(Icons.favorite_outline_rounded,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('${post.likes}',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(width: 12),
                ],
                if (post.comments != null) ...[
                  const Icon(Icons.chat_bubble_outline_rounded,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('${post.comments}',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textMuted)),
                ],
                const Spacer(),
                _SentimentBadge(label: sentiment, color: sentColor),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Coin Signals Tab ──────────────────────────────────────────────────────────

class _CoinSignalsTab extends ConsumerWidget {
  const _CoinSignalsTab();

  static const _presets = [
    ('bitcoin', 'BTC'),
    ('ethereum', 'ETH'),
    ('solana', 'SOL'),
    ('binancecoin', 'BNB'),
    ('ripple', 'XRP'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(sentimentCoinIdProvider);
    final data = ref.watch(coinSentimentProvider(selectedId));

    return Column(
      children: [
        // Coin picker
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: _presets.map((preset) {
              final (id, sym) = preset;
              final active = selectedId == id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => ref
                      .read(sentimentCoinIdProvider.notifier)
                      .state = id,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.brandGreen.withAlpha(25)
                          : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active
                            ? AppColors.brandGreen.withAlpha(80)
                            : AppColors.borderSubtle,
                      ),
                    ),
                    child: Text(sym,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: active
                                ? AppColors.brandGreen
                                : AppColors.textMuted)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: data.when(
            loading: () => const _LoadingView(),
            error: (e, _) => _ErrorView(
              message: e.toString(),
              onRetry: () =>
                  ref.invalidate(coinSentimentProvider(selectedId)),
            ),
            data: (d) => RefreshIndicator(
              color: AppColors.brandGreen,
              backgroundColor: AppColors.bgSecondary,
              onRefresh: () async =>
                  ref.invalidate(coinSentimentProvider(selectedId)),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  _CoinOverallCard(data: d),
                  if (d.signals.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Signal Breakdown',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 14),
                          ...d.signals.map((s) =>
                              _SignalRow(signal: s)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoinOverallCard extends StatelessWidget {
  final CoinSentimentData data;
  const _CoinOverallCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final sentiment = data.overallSentiment.toLowerCase();
    final color = sentiment == 'bullish'
        ? AppColors.brandGreen
        : sentiment == 'bearish'
            ? AppColors.brandRed
            : AppColors.brandAmber;

    return GlassCard(
      borderColor: color.withAlpha(40),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.symbol.isNotEmpty
                      ? '${data.symbol}/USDT'
                      : data.coinId,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text('Overall Sentiment',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.overallScore.toStringAsFixed(0),
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: color,
                    fontFamily: 'JetBrainsMono'),
              ),
              _SentimentBadge(
                  label: data.overallSentiment, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalRow extends StatelessWidget {
  final CoinSignal signal;
  const _SignalRow({required this.signal});

  Color _color(String s) {
    switch (s.toLowerCase()) {
      case 'bullish':
        return AppColors.brandGreen;
      case 'bearish':
        return AppColors.brandRed;
      default:
        return AppColors.brandAmber;
    }
  }

  IconData _icon(String type) {
    switch (type.toLowerCase()) {
      case 'social':
        return Icons.people_rounded;
      case 'onchain':
      case 'on-chain':
      case 'on_chain':
        return Icons.account_tree_rounded;
      case 'news':
        return Icons.article_rounded;
      case 'technical':
        return Icons.candlestick_chart_rounded;
      default:
        return Icons.insights_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(signal.signal);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon(signal.type), size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_capitalize(signal.type),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const Spacer(),
                    if (signal.confidence != null)
                      Text(
                          '${signal.confidence!.toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: color,
                              fontFamily: 'JetBrainsMono')),
                    const SizedBox(width: 6),
                    _SentimentBadge(
                        label: signal.signal, color: color),
                  ],
                ),
                if (signal.description != null) ...[
                  const SizedBox(height: 3),
                  Text(signal.description!,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          height: 1.4)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── On-Chain Tab ──────────────────────────────────────────────────────────────

class _OnChainTab extends ConsumerWidget {
  const _OnChainTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onChainSentimentProvider);
    return data.when(
      loading: () => const _LoadingView(),
      error: (e, _) => _ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(onChainSentimentProvider),
      ),
      data: (d) => RefreshIndicator(
        color: AppColors.brandGreen,
        backgroundColor: AppColors.bgSecondary,
        onRefresh: () async => ref.invalidate(onChainSentimentProvider),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (d.flows != null) ...[
              _ExchangeFlowsCard(flows: d.flows!),
              const SizedBox(height: 16),
            ],
            if (d.aiSummary != null && d.aiSummary!.isNotEmpty) ...[
              _AiSummaryCard(text: d.aiSummary!),
              const SizedBox(height: 16),
            ],
            if (d.indicators.isNotEmpty)
              _IndicatorsCard(indicators: d.indicators),
            if (d.flows == null &&
                d.indicators.isEmpty &&
                d.aiSummary == null)
              const _EmptyView(message: 'No on-chain data available'),
          ],
        ),
      ),
    );
  }
}

class _ExchangeFlowsCard extends StatelessWidget {
  final ExchangeFlows flows;
  const _ExchangeFlowsCard({required this.flows});

  @override
  Widget build(BuildContext context) {
    final netPositive = flows.netFlow >= 0;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Exchange Flows',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 14),
          Row(
            children: [
              _FlowMetric(
                'Inflow',
                _formatFlow(flows.inflow),
                AppColors.brandRed,
                Icons.arrow_downward_rounded,
              ),
              const SizedBox(width: 10),
              _FlowMetric(
                'Outflow',
                _formatFlow(flows.outflow),
                AppColors.brandGreen,
                Icons.arrow_upward_rounded,
              ),
              const SizedBox(width: 10),
              _FlowMetric(
                'Net Flow',
                '${netPositive ? '+' : ''}${_formatFlow(flows.netFlow)}',
                netPositive ? AppColors.brandRed : AppColors.brandGreen,
                netPositive
                    ? Icons.warning_rounded
                    : Icons.trending_up_rounded,
              ),
            ],
          ),
          if (flows.reserve != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Exchange Reserve',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
                const Spacer(),
                Text(_formatFlow(flows.reserve!),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'JetBrainsMono')),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (netPositive
                      ? AppColors.brandRed
                      : AppColors.brandGreen)
                  .withAlpha(10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: (netPositive
                          ? AppColors.brandRed
                          : AppColors.brandGreen)
                      .withAlpha(25)),
            ),
            child: Text(
              netPositive
                  ? 'Net inflow to exchanges — potential sell pressure. Monitor support levels.'
                  : 'Net outflow from exchanges — coins moving to cold storage. Bullish signal.',
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFlow(double v) {
    final abs = v.abs();
    if (abs >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (abs >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _FlowMetric extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _FlowMetric(this.label, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(25)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontFamily: 'JetBrainsMono'),
                textAlign: TextAlign.center),
            Text(label,
                style: const TextStyle(
                    fontSize: 9, color: AppColors.textMuted),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _AiSummaryCard extends StatelessWidget {
  final String text;
  const _AiSummaryCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.brandAmber.withAlpha(40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.brandAmber.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.psychology_rounded,
                size: 14, color: AppColors.brandAmber),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _IndicatorsCard extends StatelessWidget {
  final List<OnChainIndicator> indicators;
  const _IndicatorsCard({required this.indicators});

  Color _signalColor(String s) {
    final lower = s.toLowerCase();
    if (lower.contains('bull') ||
        lower.contains('safe') ||
        lower.contains('profit') ||
        lower.contains('good') ||
        lower.contains('opportun')) {
      return AppColors.brandGreen;
    }
    if (lower.contains('bear') ||
        lower.contains('risk') ||
        lower.contains('danger') ||
        lower.contains('loss')) {
      return AppColors.brandRed;
    }
    return AppColors.brandAmber;
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('On-Chain Indicators',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 14),
          ...indicators.map((m) {
            final color = _signalColor(m.signal);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(m.name,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const Spacer(),
                      Text(m.value,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: color,
                              fontFamily: 'JetBrainsMono')),
                      const SizedBox(width: 8),
                      _SentimentBadge(label: m.signal, color: color),
                    ],
                  ),
                  if (m.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(m.description,
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                            height: 1.4)),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _SentimentBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _SentimentBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
          color: AppColors.brandGreen, strokeWidth: 2),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.textMuted, size: 40),
          const SizedBox(height: 8),
          Text(message,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textMuted),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry',
                style: TextStyle(color: AppColors.brandGreen)),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String message;
  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message,
          style: const TextStyle(
              fontSize: 13, color: AppColors.textMuted)),
    );
  }
}
