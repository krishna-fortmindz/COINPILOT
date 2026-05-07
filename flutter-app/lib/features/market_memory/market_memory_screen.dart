import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';

class MarketMemoryScreen extends StatelessWidget {
  const MarketMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            const SizedBox(height: 20),
            _CurrentStateCard(),
            const SizedBox(height: 20),
            const SectionHeader(
              title: 'Similar Historical Patterns',
              subtitle: 'Ranked by structural similarity',
            ),
            const SizedBox(height: 12),
            ..._patterns.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PatternCard(pattern: p),
            )),
          ],
        ),
      ),
    );
  }

  static const _patterns = [
    _Pattern(
      date: 'October 2024',
      title: 'Pre-ATH Breakout Phase',
      similarity: 87,
      outcome: '+34% over 45 days',
      positive: true,
      description: 'RSI breakout from 55 zone, ETF inflows surge, funding neutral. '
          'Market structure showed higher highs and higher lows for 3 weeks before explosive move.',
      keyFactors: ['RSI 65-70', 'ETF net positive', 'Funding neutral', 'Exchange outflows'],
    ),
    _Pattern(
      date: 'March 2024',
      title: 'Pre-Halving Accumulation',
      similarity: 71,
      outcome: '+28% over 30 days',
      positive: true,
      description: 'Low funding rates, whale accumulation, exchange outflows increasing. '
          'Similar liquidity profile with minimal retail leverage.',
      keyFactors: ['Low funding', 'Whale accumulation', 'OI stable', 'Exchange outflows'],
    ),
    _Pattern(
      date: 'January 2023',
      title: 'Recovery Rally from Capitulation',
      similarity: 63,
      outcome: '+18% over 21 days',
      positive: true,
      description: 'Bottom formation after capitulation, sentiment shifting from extreme fear. '
          'RSI recovering from 28 to 50 range before acceleration.',
      keyFactors: ['RSI recovery', 'Fear to Neutral', 'Low OI', 'Seller exhaustion'],
    ),
    _Pattern(
      date: 'November 2021',
      title: 'Distribution Phase Before Drop',
      similarity: 34,
      outcome: '-28% over 60 days',
      positive: false,
      description: 'Note: Low similarity — included as counterexample. Funding was highly positive, '
          'over-leveraged, retail FOMO at peak. Current conditions differ significantly.',
      keyFactors: ['High funding +0.08%', 'Retail FOMO', 'Peak OI', 'Low exchange outflows'],
    ),
  ];
}

class _Pattern {
  final String date;
  final String title;
  final int similarity;
  final String outcome;
  final bool positive;
  final String description;
  final List<String> keyFactors;

  const _Pattern({
    required this.date,
    required this.title,
    required this.similarity,
    required this.outcome,
    required this.positive,
    required this.description,
    required this.keyFactors,
  });
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.brandPurple.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.brandPurple.withAlpha(40)),
          ),
          child: const Icon(Icons.history_edu_rounded, color: AppColors.brandPurple, size: 20),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Market Memory Engine', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white,
            )),
            Text('RAG-powered historical pattern matching · BTC/USDT', style: TextStyle(
              fontSize: 12, color: AppColors.textMuted,
            )),
          ],
        ),
        const Spacer(),
        NeonBadge(label: 'RAG + GPT-4', color: AppColors.brandPurple,
          icon: Icons.memory_rounded),
      ],
    );
  }
}

class _CurrentStateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.brandGreen.withAlpha(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: AppColors.brandGreen, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              const Text('Current Market State', style: TextStyle(
                fontSize: 11, color: AppColors.textMuted, letterSpacing: 0.5,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StateChip('BTC \$97,420', AppColors.brandGreen),
              _StateChip('RSI 67', AppColors.brandAmber),
              _StateChip('Funding +0.023%', AppColors.brandGreen),
              _StateChip('ETF Inflows +', AppColors.brandGreen),
              _StateChip('Whale Accumulation', AppColors.brandPurple),
              _StateChip('OI +12.4%', AppColors.brandBlue),
              _StateChip('Exchange Outflows', AppColors.brandGreen),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.brandPurple.withAlpha(10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.brandPurple.withAlpha(25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology_rounded, color: AppColors.brandPurple, size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Current BTC structure most closely resembles the October 2024 breakout phase '
                    'with 87% structural similarity. Historical outcome: +34% over 45 days.',
                    style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF), height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StateChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Text(label, style: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w600, color: color,
      )),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final _Pattern pattern;
  const _PatternCard({super.key, required this.pattern});

  @override
  Widget build(BuildContext context) {
    final similarityColor = pattern.similarity > 75
        ? AppColors.brandGreen
        : pattern.similarity > 55
            ? AppColors.brandAmber
            : AppColors.brandRed;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgTertiary,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(pattern.date, style: const TextStyle(
                  fontSize: 10, color: AppColors.textMuted, fontFamily: 'JetBrainsMono',
                )),
              ),
              const Spacer(),
              Text('${pattern.similarity}% match', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: similarityColor,
                fontFamily: 'JetBrainsMono',
              )),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pattern.similarity / 100,
                    backgroundColor: AppColors.borderSubtle,
                    valueColor: AlwaysStoppedAnimation(similarityColor),
                    minHeight: 5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(pattern.title, style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
          )),
          const SizedBox(height: 8),
          Text(pattern.description, style: const TextStyle(
            fontSize: 12, color: AppColors.textMuted, height: 1.6,
          )),
          const SizedBox(height: 12),
          Wrap(spacing: 6, runSpacing: 6, children: pattern.keyFactors.map((f) =>
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bgTertiary,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(f, style: const TextStyle(
                fontSize: 10, color: AppColors.textMuted,
              )),
            ),
          ).toList()),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                pattern.positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 16,
                color: pattern.positive ? AppColors.brandGreen : AppColors.brandRed,
              ),
              const SizedBox(width: 6),
              Text('Historical Outcome: ', style: const TextStyle(
                fontSize: 12, color: AppColors.textMuted,
              )),
              Text(pattern.outcome, style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700,
                color: pattern.positive ? AppColors.brandGreen : AppColors.brandRed,
                fontFamily: 'JetBrainsMono',
              )),
            ],
          ),
        ],
      ),
    );
  }
}
