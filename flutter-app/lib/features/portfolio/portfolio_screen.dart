import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../providers/portfolio_provider.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(portfolioProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.brandGreen),
        ),
        error: (e, _) => _buildError(ref, e.toString()),
        data: (data) => data.isEmpty
            ? _buildEmpty(ref)
            : _buildContent(context, ref, data),
      ),
    );
  }

  Widget _buildError(WidgetRef ref, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.brandRed, size: 40),
            const SizedBox(height: 12),
            Text('Failed to load portfolio',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.invalidate(portfolioProvider),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.black),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(ref),
                const SizedBox(height: 32),
                _buildConnectCard(),
                const SizedBox(height: 20),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('No Holdings Found',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      const Text(
                        'Connect an exchange or add trades manually to track your portfolio performance.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, PortfolioData data) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(ref),
                const SizedBox(height: 20),
                _buildPortfolioValue(data),
                const SizedBox(height: 16),
                if (data.equityCurve.isNotEmpty) ...[
                  _buildEquityCurve(data.equityCurve),
                  const SizedBox(height: 20),
                ],
                LayoutBuilder(builder: (_, c) {
                  if (c.maxWidth < 700) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHoldingsList(data.holdings),
                        const SizedBox(height: 16),
                        _buildAllocation(data),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3, child: _buildHoldingsList(data.holdings)),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildAllocation(data)),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                _buildConnectCard(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Portfolio',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  )),
              Text('Holdings · P&L · Equity curve · Allocation',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => ref.invalidate(portfolioProvider),
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildPortfolioValue(PortfolioData data) {
    final positive = data.totalPnl >= 0;
    return GlassCard(
      borderColor: positive
          ? AppColors.brandGreen.withAlpha(30)
          : AppColors.brandRed.withAlpha(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Portfolio Value',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Text('\$${data.totalValue.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'JetBrainsMono',
                  letterSpacing: -1)),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                positive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 14,
                color: positive ? AppColors.brandGreen : AppColors.brandRed,
              ),
              const SizedBox(width: 4),
              Text(
                '${positive ? '+' : ''}\$${data.totalPnl.toStringAsFixed(2)} '
                '(${positive ? '+' : ''}${data.totalPnlPct.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: positive ? AppColors.brandGreen : AppColors.brandRed,
                  fontFamily: 'JetBrainsMono',
                ),
              ),
              const SizedBox(width: 8),
              const Text('All time',
                  style:
                      TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquityCurve(List<EquityPoint> curve) {
    final spots = curve
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
        .toList();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Equity Curve (${curve.length}d)',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                      color: AppColors.borderSubtle, strokeWidth: 0.5),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.brandGreen,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.brandGreen.withAlpha(20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingsList(List<PortfolioHolding> holdings) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Holdings (${holdings.length})',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 14),
          ...holdings.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: h.color.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          h.symbol.isNotEmpty
                              ? h.symbol[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: h.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.symbol,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Text(
                              '${h.amount} · Avg \$${h.avgBuy.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${h.value.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'JetBrainsMono')),
                        Text(
                          '${h.positive ? '+' : ''}\$${h.pnl.toStringAsFixed(0)} '
                          '(${h.positive ? '+' : ''}${h.pnlPct.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: h.positive
                                ? AppColors.brandGreen
                                : AppColors.brandRed,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAllocation(PortfolioData data) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Allocation',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 16),
          ...data.holdings.map((h) {
            final pct = data.totalValue > 0 ? h.value / data.totalValue : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: h.color, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(h.symbol,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white)),
                      const Spacer(),
                      Text('${(pct * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: h.color,
                              fontFamily: 'JetBrainsMono')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppColors.borderSubtle,
                      valueColor: AlwaysStoppedAnimation(h.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.pie_chart_outline_rounded,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text('${data.holdings.length} assets',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textMuted)),
              const Spacer(),
              NeonBadge(
                  label: 'Live data', color: AppColors.brandGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectCard() {
    return GlassCard(
      borderColor: AppColors.brandBlue.withAlpha(30),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.link_rounded,
                color: AppColors.brandBlue, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Connect Your Exchange',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                SizedBox(height: 2),
                Text(
                    'Sync real portfolio data from Binance, Bybit, or OKX via read-only API',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.brandBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Connect',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
