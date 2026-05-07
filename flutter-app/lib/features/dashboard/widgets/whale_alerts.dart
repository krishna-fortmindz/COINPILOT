import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class WhaleAlerts extends StatelessWidget {
  const WhaleAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Whale Alerts',
            subtitle: 'Large transactions · Real-time',
          ),
          const SizedBox(height: 12),
          ..._alerts.map((a) => _AlertRow(alert: a)),
        ],
      ),
    );
  }

  static const _alerts = [
    _Alert('🐋', '2,840 BTC', 'Unknown → Binance', '4m ago', true),
    _Alert('🏦', '14,200 ETH', 'Coinbase → Unknown', '12m ago', false),
    _Alert('🐋', '85M USDT', 'Binance → Unknown', '28m ago', false),
    _Alert('🔴', '1,200 BTC', 'Kraken → Unknown', '45m ago', true),
    _Alert('🐋', '9,500 ETH', 'Unknown → OKX', '1h ago', true),
  ];
}

class _Alert {
  final String emoji;
  final String amount;
  final String direction;
  final String time;
  final bool toExchange;
  const _Alert(this.emoji, this.amount, this.direction, this.time, this.toExchange);
}

class _AlertRow extends StatelessWidget {
  final _Alert alert;
  const _AlertRow({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Center(child: Text(alert.emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.amount, style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: Colors.white, fontFamily: 'JetBrainsMono',
                )),
                Text(alert.direction, style: const TextStyle(
                  fontSize: 10, color: AppColors.textMuted,
                )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(alert.time, style: const TextStyle(
                fontSize: 10, color: AppColors.textDisabled,
              )),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: (alert.toExchange ? AppColors.brandRed : AppColors.brandAmber)
                      .withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  alert.toExchange ? 'To Exchange' : 'From Exchange',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: alert.toExchange ? AppColors.brandRed : AppColors.brandAmber,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
