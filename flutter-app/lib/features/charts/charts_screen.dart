import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  String _timeframe = '4H';
  String _indicator = 'RSI';
  final _timeframes = ['1m', '5m', '15m', '1H', '4H', '1D', '1W'];
  final _indicators = ['RSI', 'MACD', 'EMA', 'Volume', 'Bollinger'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChartHeader(
              timeframe: _timeframe,
              timeframes: _timeframes,
              onTimeframeChanged: (t) => setState(() => _timeframe = t),
              indicator: _indicator,
              indicators: _indicators,
              onIndicatorChanged: (i) => setState(() => _indicator = i),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: GlassCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    _ChartToolbar(),
                    Expanded(child: _CandlestickChart()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 1,
              child: GlassCard(
                child: _IndicatorPanel(indicator: _indicator),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartHeader extends StatelessWidget {
  final String timeframe;
  final List<String> timeframes;
  final ValueChanged<String> onTimeframeChanged;
  final String indicator;
  final List<String> indicators;
  final ValueChanged<String> onIndicatorChanged;

  const _ChartHeader({
    required this.timeframe,
    required this.timeframes,
    required this.onTimeframeChanged,
    required this.indicator,
    required this.indicators,
    required this.onIndicatorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BTC/USDT', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white,
            )),
            Row(children: [
              Text('\$97,420.00', style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: AppColors.brandGreen, fontFamily: 'JetBrainsMono',
              )),
              SizedBox(width: 8),
              Text('+2.4% (24h)', style: TextStyle(
                fontSize: 12, color: AppColors.brandGreen,
              )),
            ]),
          ],
        ),
        const Spacer(),
        // Timeframe selector
        ...timeframes.map((t) => GestureDetector(
          onTap: () => onTimeframeChanged(t),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: timeframe == t ? AppColors.brandGreen.withAlpha(20) : AppColors.bgCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: timeframe == t
                    ? AppColors.brandGreen.withAlpha(60)
                    : AppColors.borderSubtle,
              ),
            ),
            child: Text(t, style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600,
              color: timeframe == t ? AppColors.brandGreen : AppColors.textMuted,
            )),
          ),
        )),
      ],
    );
  }
}

class _ChartToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          _ToolBtn(Icons.show_chart_rounded, 'Line'),
          _ToolBtn(Icons.candlestick_chart_rounded, 'Candle', active: true),
          _ToolBtn(Icons.bar_chart_rounded, 'Bar'),
          const SizedBox(width: 16),
          _ToolBtn(Icons.draw_rounded, 'Draw'),
          _ToolBtn(Icons.horizontal_rule_rounded, 'Trend'),
          _ToolBtn(Icons.grid_on_rounded, 'Fib'),
          const Spacer(),
          NeonBadge(label: 'AI Overlay ON', color: AppColors.brandGreen,
            icon: Icons.psychology_rounded),
          const SizedBox(width: 8),
          _ToolBtn(Icons.fullscreen_rounded, 'Full'),
        ],
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _ToolBtn(this.icon, this.label, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: active ? AppColors.brandGreen.withAlpha(15) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14,
            color: active ? AppColors.brandGreen : AppColors.textMuted),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500,
            color: active ? AppColors.brandGreen : AppColors.textMuted,
          )),
        ],
      ),
    );
  }
}

class _CandlestickChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CandlestickPainter(),
      child: Stack(
        children: [
          // Price labels
          Positioned(
            right: 8, top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _PriceLabel('\$98,400', AppColors.brandRed),
                const SizedBox(height: 60),
                _PriceLabel('\$97,420', AppColors.brandGreen, isActive: true),
                const SizedBox(height: 60),
                _PriceLabel('\$96,200', AppColors.textMuted),
                const SizedBox(height: 60),
                _PriceLabel('\$95,000', AppColors.brandGreen),
              ],
            ),
          ),
          // AI Analysis overlay
          Positioned(
            left: 16, top: 16,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgCard.withAlpha(220),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.brandGreen.withAlpha(30)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Pattern Detected', style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: AppColors.brandGreen, letterSpacing: 0.5,
                  )),
                  SizedBox(height: 4),
                  Text('Bull flag forming · 78% probability', style: TextStyle(
                    fontSize: 11, color: Colors.white,
                  )),
                  SizedBox(height: 2),
                  Text('Target: \$100,400 · Stop: \$95,800', style: TextStyle(
                    fontSize: 10, color: AppColors.textMuted,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final String price;
  final Color color;
  final bool isActive;
  const _PriceLabel(this.price, this.color, {this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: isActive
          ? BoxDecoration(
              color: AppColors.brandGreen,
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: Text(
        price,
        style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w600,
          color: isActive ? Colors.black : color,
          fontFamily: 'JetBrainsMono',
        ),
      ),
    );
  }
}

class _CandlestickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final candleWidth = 12.0;
    final spacing = 16.0;
    final count = (size.width / (candleWidth + spacing)).floor();
    final midY = size.height / 2;

    // Grid lines
    for (var i = 0; i < 5; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y), Offset(size.width, y),
        Paint()..color = AppColors.borderSubtle..strokeWidth = 0.5,
      );
    }

    var basePrice = 0.5;
    for (var i = 0; i < count; i++) {
      final x = spacing / 2 + i * (candleWidth + spacing);
      basePrice += (rng.nextDouble() - 0.48) * 0.04;
      basePrice = basePrice.clamp(0.2, 0.8);

      final open = basePrice;
      final close = basePrice + (rng.nextDouble() - 0.5) * 0.06;
      final high = math.max(open, close) + rng.nextDouble() * 0.03;
      final low = math.min(open, close) - rng.nextDouble() * 0.03;
      final positive = close >= open;
      final color = positive ? AppColors.brandGreen : AppColors.brandRed;

      final openY = size.height - open * size.height;
      final closeY = size.height - close.clamp(0.0, 1.0) * size.height;
      final highY = size.height - high.clamp(0.0, 1.0) * size.height;
      final lowY = size.height - low.clamp(0.0, 1.0) * size.height;

      // Wick
      canvas.drawLine(
        Offset(x + candleWidth / 2, highY),
        Offset(x + candleWidth / 2, lowY),
        Paint()..color = color.withAlpha(180)..strokeWidth = 1,
      );

      // Body
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, math.min(openY, closeY), candleWidth, (openY - closeY).abs().clamp(1.0, 200.0)),
          const Radius.circular(2),
        ),
        Paint()..color = positive ? color.withAlpha(200) : color.withAlpha(200),
      );
    }
  }

  @override
  bool shouldRepaint(_CandlestickPainter old) => false;
}

class _IndicatorPanel extends StatelessWidget {
  final String indicator;
  const _IndicatorPanel({required this.indicator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$indicator Indicator', style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted,
        )),
        const SizedBox(height: 8),
        Expanded(
          child: CustomPaint(
            painter: _IndicatorPainter(type: indicator),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  final String type;
  _IndicatorPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(12);
    final points = List.generate(60, (i) {
      if (type == 'RSI') {
        return 30.0 + rng.nextDouble() * 50;
      }
      return rng.nextDouble();
    });

    if (type == 'RSI') {
      // Overbought/oversold lines
      for (final y in [0.3, 0.7]) {
        canvas.drawLine(
          Offset(0, size.height * (1 - y)),
          Offset(size.width, size.height * (1 - y)),
          Paint()
            ..color = (y == 0.7 ? AppColors.brandRed : AppColors.brandGreen).withAlpha(60)
            ..strokeWidth = 0.5
            ..style = PaintingStyle.stroke,
        );
      }
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final normalized = type == 'RSI' ? (points[i] - 0) / 100 : points[i];
      final y = size.height - normalized * size.height;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.brandPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) => old.type != type;
}
