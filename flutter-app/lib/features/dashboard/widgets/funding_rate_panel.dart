import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/remote/data/dashboard/models/dashboard_models.dart';
import '../../../providers/dashboard_provider.dart';

class FundingRatePanel extends ConsumerWidget {
  const FundingRatePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveFundingAsync = ref.watch(liveFundingProvider);
    final restFundingAsync = ref.watch(fundingRatesProvider);

    // Resolve full list for "View All" sheet (REST data or fallback)
    final fullRates = restFundingAsync.valueOrNull?.isNotEmpty == true
        ? restFundingAsync.valueOrNull!
        : _fallback;

    // If live socket data is available, display it
    if (liveFundingAsync.hasValue && liveFundingAsync.value!.isNotEmpty) {
      final rates = liveFundingAsync.value!;
      final rows = rates.map<Widget>((r) => _FundingRow(
        symbol: r.symbol,
        rate: r.rate,
        positive: r.positive,
        formatted: r.formatted,
        isHigh: r.isHigh,
        interpretation: r.interpretation,
      )).toList();
      return _buildCard(context, rows: rows, isLive: true, allRates: fullRates);
    }

    // Fallback to REST
    return restFundingAsync.when(
      loading: _buildShimmer,
      error: (_, __) => _buildCard(
        context,
        rows: _fallback.map<Widget>((r) => _FundingRow(
          symbol: r.symbol, rate: r.rate, positive: r.positive,
          formatted: r.formatted, isHigh: r.isHigh, interpretation: r.interpretation,
        )).toList(),
        isLive: false,
        allRates: _fallback,
      ),
      data: (rates) {
        final list = rates.isNotEmpty ? rates : _fallback;
        final rows = list.map<Widget>((r) => _FundingRow(
          symbol: r.symbol, rate: r.rate, positive: r.positive,
          formatted: r.formatted, isHigh: r.isHigh, interpretation: r.interpretation,
        )).toList();
        return _buildCard(context, rows: rows, isLive: false, allRates: list);
      },
    );
  }

  static Widget _buildShimmer() => Shimmer.fromColors(
    baseColor: AppColors.bgCard,
    highlightColor: AppColors.bgTertiary,
    child: Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    ),
  );

  Widget _buildCard(
    BuildContext context, {
    required List<Widget> rows,
    required bool isLive,
    required List<FundingRate> allRates,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionHeader(
                  title: 'Funding Rates',
                  subtitle: 'Perpetual futures · 8h intervals',
                ),
              ),
              if (isLive) ...[
                const NeonBadge(label: 'LIVE', color: AppColors.brandGreen),
                const SizedBox(width: 8),
              ],
              GestureDetector(
                onTap: () => _showAllRates(context, allRates),
                child: const Text(
                  'View All',
                  style: TextStyle(fontSize: 11, color: AppColors.brandGreen, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }

  void _showAllRates(BuildContext context, List<FundingRate> rates) {
    // Sort by absolute rate, highest first
    final sorted = [...rates]..sort((a, b) => b.rate.abs().compareTo(a.rate.abs()));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (sheetCtx, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderDefault,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'All Funding Rates',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  itemCount: sorted.length,
                  itemBuilder: (_, i) {
                    final r = sorted[i];
                    return _FundingRow(
                      symbol: r.symbol,
                      rate: r.rate,
                      positive: r.positive,
                      formatted: r.formatted,
                      isHigh: r.isHigh,
                      interpretation: r.interpretation,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final _fallback = [
    const FundingRate(symbol: 'BTCUSDT', rate: 0.00023),
    const FundingRate(symbol: 'ETHUSDT', rate: 0.00018),
    const FundingRate(symbol: 'SOLUSDT', rate: -0.00008),
    const FundingRate(symbol: 'BNBUSDT', rate: 0.00031),
    const FundingRate(symbol: 'ARBUSDT', rate: 0.00045),
  ];
}

class _FundingRow extends StatelessWidget {
  final String symbol;
  final double rate;
  final bool positive;
  final String formatted;
  final bool isHigh;
  final String interpretation;

  const _FundingRow({
    required this.symbol,
    required this.rate,
    required this.positive,
    required this.formatted,
    required this.isHigh,
    required this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.brandGreen : AppColors.brandRed;
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
                    Text(symbol,
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                    if (isHigh) ...[
                      const SizedBox(width: 6),
                      const NeonBadge(label: 'HIGH', color: AppColors.brandAmber),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(interpretation,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(formatted,
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: color, fontFamily: 'JetBrainsMono',
            )),
        ],
      ),
    );
  }
}
