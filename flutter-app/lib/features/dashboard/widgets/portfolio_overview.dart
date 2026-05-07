import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class PortfolioOverview extends StatelessWidget {
  const PortfolioOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Portfolio', subtitle: 'Read-only sync · Binance'),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Value', style: TextStyle(
                      fontSize: 11, color: AppColors.textMuted,
                    )),
                    SizedBox(height: 4),
                    Text('\$42,840', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800,
                      color: Colors.white, fontFamily: 'JetBrainsMono',
                    )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('24h Change', style: TextStyle(
                    fontSize: 11, color: AppColors.textMuted,
                  )),
                  SizedBox(height: 4),
                  Text('+\$1,240 (+2.97%)', style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.brandGreen, fontFamily: 'JetBrainsMono',
                  )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 12),
          ..._holdings.map((h) => _HoldingRow(holding: h)),
        ],
      ),
    );
  }

  static const _holdings = [
    _Holding('BTC', '0.42', '\$40.9K', 95.5, AppColors.brandGreen),
    _Holding('ETH', '2.1', '\$807', 1.9, AppColors.brandBlue),
    _Holding('SOL', '7.8', '\$1.43K', 3.3, Color(0xFF9945FF)),
  ];
}

class _Holding {
  final String symbol;
  final String amount;
  final String value;
  final double allocation;
  final Color color;
  const _Holding(this.symbol, this.amount, this.value, this.allocation, this.color);
}

class _HoldingRow extends StatelessWidget {
  final _Holding holding;
  const _HoldingRow({super.key, required this.holding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: holding.color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                holding.symbol[0],
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800, color: holding.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holding.symbol, style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                )),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: holding.allocation / 100,
                          backgroundColor: AppColors.borderSubtle,
                          valueColor: AlwaysStoppedAnimation(holding.color),
                          minHeight: 3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${holding.allocation.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(holding.value, style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: Colors.white, fontFamily: 'JetBrainsMono',
              )),
              Text(holding.amount, style: const TextStyle(
                fontSize: 10, color: AppColors.textMuted,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
