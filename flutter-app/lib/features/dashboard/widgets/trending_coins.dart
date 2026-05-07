import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class TrendingCoins extends StatelessWidget {
  const TrendingCoins({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Trending',
            subtitle: 'Most searched · Last 24h',
          ),
          const SizedBox(height: 12),
          ..._coins.asMap().entries.map((e) => _TrendingRow(
            rank: e.key + 1,
            coin: e.value,
          )),
        ],
      ),
    );
  }

  static const _coins = [
    _Coin('BTC', 'Bitcoin', '+2.4%', true, '🔥'),
    _Coin('SOL', 'Solana', '-0.9%', false, '⚡'),
    _Coin('PEPE', 'Pepe', '+18.2%', true, '🐸'),
    _Coin('ARK', 'ARK', '+42.0%', true, '🚀'),
    _Coin('ONDO', 'Ondo Finance', '+8.7%', true, '🏦'),
    _Coin('WIF', 'Dogwifhat', '-3.2%', false, '🐕'),
  ];
}

class _Coin {
  final String symbol;
  final String name;
  final String change;
  final bool positive;
  final String emoji;
  const _Coin(this.symbol, this.name, this.change, this.positive, this.emoji);
}

class _TrendingRow extends StatelessWidget {
  final int rank;
  final _Coin coin;
  const _TrendingRow({super.key, required this.rank, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontSize: 10, color: AppColors.textDisabled, fontFamily: 'JetBrainsMono',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(coin.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coin.symbol, style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                )),
                Text(coin.name, style: const TextStyle(
                  fontSize: 10, color: AppColors.textMuted,
                )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (coin.positive ? AppColors.brandGreen : AppColors.brandRed).withAlpha(20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              coin.change,
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: coin.positive ? AppColors.brandGreen : AppColors.brandRed,
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
