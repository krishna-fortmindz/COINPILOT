import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'sidebar.dart';
import 'top_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isTablet = width >= 768 && width < 1024;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: isDesktop
          ? Row(
              children: [
                const AppSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      const TopBar(),
                      Expanded(
                        child: ClipRect(
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const TopBar(),
                Expanded(child: child),
                _BottomNav(currentRoute: GoRouterState.of(context).uri.path),
              ],
            ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final String currentRoute;
  const _BottomNav({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('/dashboard', Icons.dashboard_rounded, 'Home'),
      _NavItem('/analysis', Icons.psychology_rounded, 'AI'),
      _NavItem('/charts', Icons.candlestick_chart_rounded, 'Charts'),
      _NavItem('/chat', Icons.chat_bubble_rounded, 'Chat'),
      _NavItem('/profile', Icons.person_rounded, 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final active = currentRoute == item.route;
            return Expanded(
              child: GestureDetector(
                onTap: () => context.go(item.route),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: active ? AppColors.brandGreen : AppColors.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: active ? AppColors.brandGreen : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final String route;
  final IconData icon;
  final String label;
  _NavItem(this.route, this.icon, this.label);
}
