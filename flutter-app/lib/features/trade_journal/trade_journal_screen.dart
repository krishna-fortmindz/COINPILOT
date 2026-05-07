import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';

class TradeJournalScreen extends StatefulWidget {
  const TradeJournalScreen({super.key});

  @override
  State<TradeJournalScreen> createState() => _TradeJournalScreenState();
}

class _TradeJournalScreenState extends State<TradeJournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.brandGreen,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          _JournalHeader(tabController: _tabs),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _TradesTab(),
                _AnalyticsTab(),
                _PsychologyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalHeader extends StatelessWidget {
  final TabController tabController;
  const _JournalHeader({required this.tabController});

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
                  Text('Trade Journal', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white,
                  )),
                  Text('Track, analyze, and improve your trading psychology', style: TextStyle(
                    fontSize: 12, color: AppColors.textMuted,
                  )),
                ],
              ),
              const Spacer(),
              _StatBadge('Win Rate', '68%', AppColors.brandGreen),
              const SizedBox(width: 8),
              _StatBadge('P&L', '+\$8,240', AppColors.brandGreen),
              const SizedBox(width: 8),
              _StatBadge('Trades', '42', AppColors.brandBlue),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.brandGreen,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.brandGreen,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Trade Log'),
              Tab(text: 'Analytics'),
              Tab(text: 'AI Psychology'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBadge(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w800, color: color, fontFamily: 'JetBrainsMono',
          )),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _TradesTab extends StatelessWidget {
  final _trades = const [
    _Trade('BTC/USDT', 'Long', '\$94,200', '\$97,100', '+\$580', true, 'Calm', '2h ago'),
    _Trade('ETH/USDT', 'Long', '\$3,720', '\$3,842', '+\$244', true, 'Confident', '6h ago'),
    _Trade('SOL/USDT', 'Short', '\$188', '\$182', '+\$120', true, 'Nervous', '1d ago'),
    _Trade('BNB/USDT', 'Long', '\$620', '\$598', '-\$220', false, 'FOMO', '2d ago'),
    _Trade('ARB/USDT', 'Long', '\$1.18', '\$1.31', '+\$260', true, 'Calm', '3d ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _trades.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _TradeRow(trade: _trades[i]),
    );
  }
}

class _Trade {
  final String pair, direction, entry, exit, pnl;
  final bool positive;
  final String emotion, time;
  const _Trade(this.pair, this.direction, this.entry, this.exit, this.pnl,
    this.positive, this.emotion, this.time);
}

class _TradeRow extends StatelessWidget {
  final _Trade trade;
  const _TradeRow({super.key, required this.trade});

  @override
  Widget build(BuildContext context) {
    final emotionColor = trade.emotion == 'Calm' || trade.emotion == 'Confident'
        ? AppColors.brandGreen
        : trade.emotion == 'FOMO'
            ? AppColors.brandRed
            : AppColors.brandAmber;

    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: (trade.direction == 'Long' ? AppColors.brandGreen : AppColors.brandRed)
                  .withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              trade.direction == 'Long' ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              color: trade.direction == 'Long' ? AppColors.brandGreen : AppColors.brandRed,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(trade.pair, style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white,
                    )),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: emotionColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('😐 ${trade.emotion}', style: TextStyle(
                        fontSize: 9, color: emotionColor,
                      )),
                    ),
                  ],
                ),
                Text('Entry ${trade.entry} → Exit ${trade.exit}', style: const TextStyle(
                  fontSize: 10, color: AppColors.textMuted, fontFamily: 'JetBrainsMono',
                )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(trade.pnl, style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: trade.positive ? AppColors.brandGreen : AppColors.brandRed,
                fontFamily: 'JetBrainsMono',
              )),
              Text(trade.time, style: const TextStyle(
                fontSize: 10, color: AppColors.textDisabled,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: MetricCard(
                label: 'Win Rate', value: '68%',
                icon: Icons.emoji_events_rounded, iconColor: AppColors.brandGreen,
              )),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(
                label: 'Profit Factor', value: '2.4x',
                icon: Icons.trending_up_rounded, iconColor: AppColors.brandBlue,
              )),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(
                label: 'Avg RR Ratio', value: '1:2.1',
                icon: Icons.balance_rounded, iconColor: AppColors.brandAmber,
              )),
            ],
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Performance by Emotion', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
                )),
                const SizedBox(height: 16),
                _EmotionBar('Calm', 82, 15, AppColors.brandGreen),
                _EmotionBar('Confident', 74, 12, AppColors.brandBlue),
                _EmotionBar('Nervous', 45, 8, AppColors.brandAmber),
                _EmotionBar('FOMO', 22, 5, AppColors.brandRed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmotionBar extends StatelessWidget {
  final String emotion;
  final int winRate;
  final int trades;
  final Color color;
  const _EmotionBar(this.emotion, this.winRate, this.trades, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(emotion, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const Spacer(),
              Text('$trades trades', style: const TextStyle(fontSize: 10, color: AppColors.textDisabled)),
              const SizedBox(width: 12),
              Text('$winRate% WR', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: color, fontFamily: 'JetBrainsMono',
              )),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: winRate / 100,
              backgroundColor: AppColors.borderSubtle,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PsychologyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GlassCard(
            borderColor: AppColors.brandRed.withAlpha(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.brandRed.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.psychology_rounded,
                        color: AppColors.brandRed, size: 16),
                    ),
                    const SizedBox(width: 10),
                    const Text('AI Psychology Insights', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                ...[
                  'You lose 78% of trades entered with "FOMO" emotion. Consider a 30-minute cooldown rule before entering.',
                  'Your win rate drops from 74% to 22% after 2 consecutive losses. Revenge trading pattern detected.',
                  'Best performance: Calm + 1H timeframe + Morning sessions. Consider limiting evening trades.',
                  'Your average loss is 2.3x your average win. Tighten stop losses or improve RR targeting.',
                ].map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.brandAmber.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lightbulb_outline_rounded,
                          size: 12, color: AppColors.brandAmber),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(insight, style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted, height: 1.5,
                      ))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
