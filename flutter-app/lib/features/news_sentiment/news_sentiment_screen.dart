import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';

class NewsSentimentScreen extends StatefulWidget {
  const NewsSentimentScreen({super.key});

  @override
  State<NewsSentimentScreen> createState() => _NewsSentimentScreenState();
}

class _NewsSentimentScreenState extends State<NewsSentimentScreen>
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
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        children: [
          _Header(tabController: _tabs),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _NewsTab(),
                _TwitterTab(),
                _RedditTab(),
                _WhaleTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TabController tabController;
  const _Header({required this.tabController});

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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('News & Sentiment', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white,
                  )),
                  Text('Real-time market sentiment aggregation', style: TextStyle(
                    fontSize: 12, color: AppColors.textMuted,
                  )),
                ],
              ),
              const Spacer(),
              _SentimentMeter(value: 72),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.brandGreen,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            indicatorColor: AppColors.brandGreen,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'News'),
              Tab(text: 'Twitter/X'),
              Tab(text: 'Reddit'),
              Tab(text: 'Whale Activity'),
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
    final color = value > 60 ? AppColors.brandGreen : value > 45 ? AppColors.brandAmber : AppColors.brandRed;
    final label = value > 60 ? 'Bullish' : value > 45 ? 'Neutral' : 'Bearish';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Row(
        children: [
          Text('$value', style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w900, color: color, fontFamily: 'JetBrainsMono',
          )),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: color,
              )),
              const Text('Sentiment', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewsTab extends StatelessWidget {
  final _news = const [
    _NewsItem('BlackRock Bitcoin ETF records 3rd largest inflow day ever at \$842M', 'bullish', '2h ago', 'Bloomberg'),
    _NewsItem('Federal Reserve signals rate pause in upcoming Q2 meeting', 'bullish', '4h ago', 'Reuters'),
    _NewsItem('Binance lists new DeFi token with \$400M FDV, first day volume surges', 'neutral', '5h ago', 'CoinDesk'),
    _NewsItem('BTC miner capitulation index at 5-year low, suggesting bottom is in', 'bullish', '7h ago', 'CryptoQuant'),
    _NewsItem('SEC approves Bitcoin ETF options trading on Nasdaq', 'bullish', '9h ago', 'WSJ'),
    _NewsItem('Crypto exchange hack: \$45M stolen from DeFi protocol', 'bearish', '11h ago', 'The Block'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _news.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _NewsCard(item: _news[i]),
    );
  }
}

class _NewsItem {
  final String title;
  final String sentiment;
  final String time;
  final String source;
  const _NewsItem(this.title, this.sentiment, this.time, this.source);
}

class _NewsCard extends StatelessWidget {
  final _NewsItem item;
  const _NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.sentiment == 'bullish'
        ? AppColors.brandGreen
        : item.sentiment == 'bearish'
            ? AppColors.brandRed
            : AppColors.brandAmber;

    return GlassCard(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 50,
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
                Text(item.title, style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500,
                  color: Colors.white, height: 1.4,
                )),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(item.sentiment.toUpperCase(), style: TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Text(item.source, style: const TextStyle(
                      fontSize: 10, color: AppColors.textMuted,
                    )),
                    const Spacer(),
                    Text(item.time, style: const TextStyle(
                      fontSize: 10, color: AppColors.textDisabled,
                    )),
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

class _TwitterTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Twitter/X Sentiment', style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
              )),
              const SizedBox(height: 16),
              Row(
                children: [
                  _TwitterMetric('68%', 'Bullish Tweets', AppColors.brandGreen),
                  const SizedBox(width: 12),
                  _TwitterMetric('124K', 'BTC Posts', AppColors.brandBlue),
                  const SizedBox(width: 12),
                  _TwitterMetric('+42%', 'Vol Change', AppColors.brandAmber),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.bgTertiary,
                      child: Text('@${['trader', 'whale', 'analyst', 'degen', 'bull'][i][0].toUpperCase()}',
                        style: const TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    Text('@${['cryptotrader', 'whalealert', 'btcanalyst', 'defi_degen', 'bullmarket'][i]}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                    const Spacer(),
                    Text('${[2, 5, 12, 18, 34][i]}m ago', style: const TextStyle(
                      fontSize: 10, color: AppColors.textDisabled,
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ['BTC looking extremely strong here. Higher lows on every timeframe. \$100K incoming 🚀',
                    '2,840 BTC just moved from unknown wallet to Binance. Potential sell incoming?',
                    'RSI at 67 on the daily. Still room to run before overbought territory hits.',
                    'LFG! ETF flows absolutely insane today. Institutions are not selling.',
                    'Bull market confirmed. Every dip is being bought aggressively.'][i],
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class _TwitterMetric extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _TwitterMetric(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(25)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: color,
              fontFamily: 'JetBrainsMono',
            )),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _RedditTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Reddit Sentiment', style: TextStyle(color: Colors.white)));
  }
}

class _WhaleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Whale Activity', style: TextStyle(color: Colors.white)));
  }
}
