import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/coin_selector.dart';
import '../../providers/ai_analysis_provider.dart';
import '../../providers/charts_provider.dart';
import '../../providers/exchange_flows_provider.dart';
import '../../providers/onchain_indicators_provider.dart';

class OnchainScreen extends ConsumerStatefulWidget {
  const OnchainScreen({super.key});

  @override
  ConsumerState<OnchainScreen> createState() => _OnchainScreenState();
}

class _OnchainScreenState extends ConsumerState<OnchainScreen> {
  String get _selectedCoin => ref.watch(aiAnalysisProvider.select((n) => n.selectedCoin));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildCoinSelector(),
                  const SizedBox(height: 20),
                  _buildMetricsRow(),
                  const SizedBox(height: 16),
                  _buildFlowChart(),
                  const SizedBox(height: 16),
                  LayoutBuilder(builder: (_, c) {
                    if (c.maxWidth < 700) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _OnChainMetricsCard(symbol: _selectedCoin),
                          const SizedBox(height: 16),
                          const _WhaleTransactionsList(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _OnChainMetricsCard(symbol: _selectedCoin)),
                        const SizedBox(width: 16),
                        const Expanded(child: _WhaleTransactionsList()),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildTopExchanges(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('On-Chain Analytics', style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
                letterSpacing: -0.5,
              )),
              Text('Exchange flows · Whale activity · SOPR · MVRV',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
        NeonBadge(label: 'Glassnode', color: AppColors.brandBlue),
      ],
    );
  }

  Widget _buildCoinSelector() {
    return CoinSelector(
      selected: _selectedCoin,
      onChanged: (c) {
        ref.read(aiAnalysisProvider).selectCoin(c);
        ref.read(chartsProvider).setCoin(c);
      },
    );
  }

  Widget _buildMetricsRow() {
    final flowAsync = ref.watch(exchangeFlowsNetflowProvider(_selectedCoin));
    return flowAsync.when(
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(color: AppColors.brandBlue, strokeWidth: 2)),
      ),
      error: (_, __) => _buildMetricsRowFallback(),
      data: (flow) {
        String fmt(double v) {
          if (v.abs() >= 1e9) return '${(v / 1e9).toStringAsFixed(2)}B';
          if (v.abs() >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
          if (v.abs() >= 1e3) return '${(v / 1e3).toStringAsFixed(1)}K';
          return v.toStringAsFixed(0);
        }
        final symbol = flow.symbol;
        final exchangeCount = flow.exchangeBreakdown.length;
        final tiles = [
          _FlowTile('Exchange Inflow', '${fmt(flow.totalInflow)} $symbol', '30d total', false),
          _FlowTile('Exchange Outflow', '${fmt(flow.totalOutflow)} $symbol', '30d total', true),
          _FlowTile(
            'Net Flow',
            '${flow.netflow >= 0 ? '+' : ''}${fmt(flow.netflow)} $symbol',
            flow.isBullish ? 'Bullish signal' : 'Bearish signal',
            flow.isBullish,
          ),
          _FlowTile(
            'Exchanges Tracked',
            exchangeCount > 0 ? '$exchangeCount exchanges' : '—',
            '${flow.days ?? 30}d window',
            true,
          ),
        ];
        return _metricsLayout(tiles);
      },
    );
  }

  Widget _buildMetricsRowFallback() {
    final tiles = [
      const _FlowTile('Exchange Inflow', '—', '', false),
      const _FlowTile('Exchange Outflow', '—', '', true),
      const _FlowTile('Net Flow', '—', '', false),
      const _FlowTile('Exchange Reserve', '—', '', false),
    ];
    return _metricsLayout(tiles);
  }

  Widget _metricsLayout(List<_FlowTile> tiles) {
    return LayoutBuilder(builder: (_, c) {
      if (c.maxWidth < 700) {
        return Column(
          children: [
            Row(children: [Expanded(child: tiles[0]), const SizedBox(width: 12), Expanded(child: tiles[1])]),
            const SizedBox(height: 12),
            Row(children: [Expanded(child: tiles[2]), const SizedBox(width: 12), Expanded(child: tiles[3])]),
          ],
        );
      }
      return Row(
        children: tiles.expand((t) => [t, const SizedBox(width: 12)]).toList()..removeLast(),
      );
    });
  }

  Widget _buildFlowChart() {
    final flowAsync = ref.watch(exchangeFlowsNetflowProvider(_selectedCoin));
    return flowAsync.when(
      loading: () => const GlassCard(
        child: SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator(color: AppColors.brandBlue, strokeWidth: 2)),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (flow) {
        // Build chart from exchange breakdown as proxy for per-exchange bar data
        if (flow.exchangeBreakdown.isEmpty) return const SizedBox.shrink();
        final bd = flow.exchangeBreakdown;
        final inflowSpots = bd.asMap().entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.inflow)).toList();
        final outflowSpots = bd.asMap().entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.outflow)).toList();
        final signal = flow.isBullish
            ? 'More outflow than inflow → Bullish (coins leaving exchanges)'
            : 'More inflow than outflow → Bearish (coins entering exchanges)';

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Exchange Flows (30d)', style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
                  )),
                  const Spacer(),
                  const _LegendDot(AppColors.brandGreen, 'Outflow'),
                  const SizedBox(width: 12),
                  const _LegendDot(AppColors.brandRed, 'Inflow'),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => const FlLine(
                        color: AppColors.borderSubtle,
                        strokeWidth: 0.5,
                      ),
                    ),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: outflowSpots,
                        isCurved: true,
                        color: AppColors.brandGreen,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.brandGreen.withAlpha(15),
                        ),
                      ),
                      LineChartBarData(
                        spots: inflowSpots,
                        isCurved: true,
                        color: AppColors.brandRed,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.brandRed.withAlpha(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(signal,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopExchanges() {
    final flowAsync = ref.watch(exchangeFlowsNetflowProvider(_selectedCoin));
    return flowAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (flow) {
        final breakdown = flow.exchangeBreakdown;
        if (breakdown.isEmpty) return const SizedBox.shrink();
        String fmt(double v) {
          if (v.abs() >= 1e9) return '${(v / 1e9).toStringAsFixed(1)}B';
          if (v.abs() >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
          if (v.abs() >= 1e3) return '${(v / 1e3).toStringAsFixed(0)}K';
          return v.toStringAsFixed(0);
        }
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Top Exchange Flows · ${flow.symbol}', style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
              )),
              const SizedBox(height: 14),
              ...breakdown.take(8).map((ex) {
                // netflow > 0 = net inflow to exchange = bearish (red)
                final isNetInflow = ex.netflow > 0;
                final color = isNetInflow ? AppColors.brandRed : AppColors.brandGreen;
                final sign = ex.netflow >= 0 ? '+' : '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(ex.exchange, style: const TextStyle(
                          fontSize: 12, color: Colors.white,
                        )),
                      ),
                      Text('$sign${fmt(ex.netflow)}', style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: color, fontFamily: 'JetBrainsMono',
                      )),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _FlowTile extends StatelessWidget {
  final String label, value, sub;
  final bool positive;
  const _FlowTile(this.label, this.value, this.sub, this.positive);

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.brandGreen : AppColors.brandRed;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w800,
            color: color, fontFamily: 'JetBrainsMono',
          )),
          Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}

class _OnChainMetricsCard extends ConsumerWidget {
  final String symbol;
  const _OnChainMetricsCard({required this.symbol});

  Color _levelColor(String level) {
    switch (level) {
      case 'bullish': return AppColors.brandGreen;
      case 'bearish': return AppColors.brandRed;
      default: return AppColors.brandAmber;
    }
  }

  String _fmtValue(double v) {
    if (v.abs() < 0.01) return v.toStringAsFixed(6);
    if (v.abs() < 1) return v.toStringAsFixed(4);
    if (v.abs() < 10) return v.toStringAsFixed(3);
    return v.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(onchainIndicatorsProvider(symbol));
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('On-Chain Metrics', style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
          )),
          const SizedBox(height: 14),
          async.when(
            loading: () => const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator(color: AppColors.brandBlue, strokeWidth: 2)),
            ),
            error: (_, __) => const Text('Unable to load metrics',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            data: (indicators) {
              if (indicators.isEmpty) {
                return const Text('No indicators available',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted));
              }
              return Column(
                children: indicators.map((m) {
                  final color = _levelColor(m.level);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(m.name, style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                            )),
                            const Spacer(),
                            Text(_fmtValue(m.value), style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700,
                              color: color, fontFamily: 'JetBrainsMono',
                            )),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(m.signal, style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w700, color: color,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(m.description, style: const TextStyle(
                          fontSize: 10, color: AppColors.textMuted, height: 1.4,
                        )),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WhaleTransactionsList extends StatelessWidget {
  const _WhaleTransactionsList();

  static const _txns = [
    _WhaleTxn('BTC', '2,840', '\$276.8M', 'Unknown', 'Binance', '4m ago', true),
    _WhaleTxn('ETH', '18,420', '\$70.8M', 'Coinbase', 'Unknown', '12m ago', false),
    _WhaleTxn('BTC', '1,200', '\$117.0M', 'Kraken', 'Unknown', '28m ago', false),
    _WhaleTxn('USDT', '85M', '\$85.0M', 'Tether Treasury', 'Unknown', '45m ago', false),
    _WhaleTxn('ETH', '9,800', '\$37.7M', 'Unknown', 'Coinbase', '1h ago', true),
    _WhaleTxn('BTC', '680', '\$66.2M', 'Unknown', 'Bybit', '1.5h ago', true),
    _WhaleTxn('SOL', '220K', '\$40.5M', 'Unknown', 'OKX', '2h ago', true),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Whale Transactions', style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
              )),
              const Spacer(),
              const NeonBadge(label: 'LIVE', color: AppColors.brandGreen, icon: Icons.circle),
            ],
          ),
          const SizedBox(height: 14),
          ..._txns.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: t.toExchange ? AppColors.brandRed : AppColors.brandGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${t.amount} ${t.symbol}', style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
                          )),
                          const Spacer(),
                          Text(t.usdValue, style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: t.toExchange ? AppColors.brandRed : AppColors.brandGreen,
                            fontFamily: 'JetBrainsMono',
                          )),
                        ],
                      ),
                      Text('${t.from} → ${t.to} · ${t.time}', style: const TextStyle(
                        fontSize: 10, color: AppColors.textMuted,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _WhaleTxn {
  final String symbol, amount, usdValue, from, to, time;
  final bool toExchange;
  const _WhaleTxn(this.symbol, this.amount, this.usdValue, this.from, this.to, this.time, this.toExchange);
}