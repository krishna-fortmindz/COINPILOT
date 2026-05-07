import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class AiSummaryCard extends StatefulWidget {
  const AiSummaryCard({super.key});

  @override
  State<AiSummaryCard> createState() => _AiSummaryCardState();
}

class _AiSummaryCardState extends State<AiSummaryCard> {
  static const _fullText =
      'BTC is showing strong bullish momentum. RSI at 67 — not yet overbought. Key resistance at \$98.4K. '
      'Funding rates remain neutral. ETF inflows are positive for the 3rd consecutive day. '
      'Consider scaling positions on pullbacks to the \$95K support zone. '
      'Watch for a possible liquidity sweep below \$96K before continuation.';

  int _charCount = 0;
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 20));
      if (!mounted) return false;
      setState(() {
        if (_charCount < _fullText.length) {
          _charCount++;
        } else {
          _isTyping = false;
        }
      });
      return _charCount < _fullText.length;
    });
  }

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
                decoration: const BoxDecoration(
                  color: AppColors.brandGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'AI Market Summary',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              NeonBadge(label: 'GPT-4', color: AppColors.brandPurple),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.black, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: _fullText.substring(0, _charCount),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xCCFFFFFF),
                      height: 1.6,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      if (_isTyping)
                        const WidgetSpan(
                          child: _Cursor(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 12),

          Row(
            children: [
              _SentimentChip('Bullish', 74, AppColors.brandGreen),
              const SizedBox(width: 8),
              _SentimentChip('Neutral', 18, AppColors.brandAmber),
              const SizedBox(width: 8),
              _SentimentChip('Bearish', 8, AppColors.brandRed),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text('Ask AI', style: TextStyle(
                      fontSize: 12, color: AppColors.brandGreen, fontWeight: FontWeight.w600,
                    )),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.brandGreen),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cursor extends StatefulWidget {
  const _Cursor();

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Opacity(
        opacity: _c.value,
        child: Container(
          width: 2, height: 14,
          margin: const EdgeInsets.only(left: 1),
          decoration: BoxDecoration(
            color: AppColors.brandGreen,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }
}

class _SentimentChip extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;
  const _SentimentChip(this.label, this.percent, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Text(
        '$label $percent%',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
