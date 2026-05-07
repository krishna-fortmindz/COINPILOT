import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class FundingRatePanel extends StatelessWidget {
  const FundingRatePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Funding Rates',
            subtitle: 'Perpetual futures · 8h intervals',
          ),
          const SizedBox(height: 16),
          ..._rates.map((r) => _FundingRow(rate: r)),
        ],
      ),
    );
  }

  static const _rates = [
    _Rate('BTC/USDT', '+0.023%', true, 'Bullish bias — longs paying shorts'),
    _Rate('ETH/USDT', '+0.018%', true, 'Moderate long dominance'),
    _Rate('SOL/USDT', '-0.008%', false, 'Bearish pressure — shorts paying longs'),
    _Rate('BNB/USDT', '+0.031%', true, 'High bullish sentiment'),
    _Rate('ARB/USDT', '+0.045%', true, 'Very high — potential squeeze risk'),
  ];
}

class _Rate {
  final String pair;
  final String rate;
  final bool positive;
  final String interpretation;
  const _Rate(this.pair, this.rate, this.positive, this.interpretation);
}

class _FundingRow extends StatelessWidget {
  final _Rate rate;
  const _FundingRow({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    final color = rate.positive ? AppColors.brandGreen : AppColors.brandRed;
    final isHigh = rate.positive && rate.rate.contains('0.04');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(rate.pair, style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                    )),
                    if (isHigh) ...[
                      const SizedBox(width: 6),
                      NeonBadge(label: 'HIGH', color: AppColors.brandAmber),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(rate.interpretation, style: const TextStyle(
                  fontSize: 10, color: AppColors.textMuted,
                )),
              ],
            ),
          ),
          Text(
            rate.rate,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ],
      ),
    );
  }
}
