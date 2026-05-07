import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          // Live indicator
          _LiveIndicator(),
          const SizedBox(width: 16),

          // Market ticker (desktop)
          if (MediaQuery.of(context).size.width >= 1024) ...[
            _MarketTicker(),
            const Spacer(),
          ] else
            const Spacer(),

          // Search
          _SearchButton(),
          const SizedBox(width: 8),

          // Notifications
          _NotificationButton(),
          const SizedBox(width: 8),

          // Theme toggle
          _ThemeButton(),
        ],
      ),
    );
  }
}

class _LiveIndicator extends StatefulWidget {
  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandGreen.withOpacity(0.4 + 0.6 * _controller.value),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandGreen.withOpacity(0.3 * _controller.value),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'LIVE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.brandGreen,
            letterSpacing: 1.2,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ],
    );
  }
}

class _MarketTicker extends StatelessWidget {
  final _items = const [
    _TickerItem('BTC', '\$97,420', true),
    _TickerItem('ETH', '\$3,842', true),
    _TickerItem('SOL', '\$184', false),
    _TickerItem('BNB', '\$612', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.symbol,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                fontFamily: 'JetBrainsMono',
              ),
            ),
            const SizedBox(width: 4),
            Text(
              item.price,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _TickerItem {
  final String symbol;
  final String price;
  final bool positive;
  const _TickerItem(this.symbol, this.price, this.positive);
}

class _SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TopBarButton(
      icon: Icons.search_rounded,
      onTap: () {},
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _TopBarButton(
          icon: Icons.notifications_outlined,
          onTap: () {},
        ),
        Positioned(
          top: 2, right: 2,
          child: Container(
            width: 7, height: 7,
            decoration: const BoxDecoration(
              color: AppColors.brandRed,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TopBarButton(
      icon: Icons.wb_sunny_outlined,
      onTap: () {},
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Icon(icon, size: 17, color: AppColors.textMuted),
      ),
    );
  }
}
