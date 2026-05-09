import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/orders_provider.dart';
import '../core/providers/chat_provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/utils/app_localizations.dart';
import '../core/widgets/responsive_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!app.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/auth/sign-in');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userName = app.userName ?? app.userEmail?.split('@')[0] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Small avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ThemeProvider.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: ThemeProvider.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.welcome}, $userName',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : ThemeProvider.textDark,
                  ),
                ),
                Text(
                  app.role == UserRole.provider ? l10n.provider : l10n.student,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeProvider.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/chat/inbox'),
            icon: Icon(
              Icons.notifications_none_rounded,
              color: isDark ? Colors.white70 : ThemeProvider.textMedium,
            ),
          ),
        ],
      ),
      body: ResponsiveWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Quick Stats
            _buildStatsRow(context, l10n),
            const SizedBox(height: 28),

            // Services section
            Text(
              l10n.services,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : ThemeProvider.textDark,
              ),
            ),
            const SizedBox(height: 14),

            // Service items - clean list style
            _ServiceItem(
              icon: Icons.home_outlined,
              title: l10n.housing,
              subtitle: l10n.isArabic ? 'ابحث عن سكن قريب' : 'Find nearby housing',
              color: const Color(0xFF6366F1),
              route: '/housing',
            ),
            if (app.role == UserRole.student)
              _ServiceItem(
                icon: Icons.storefront_outlined,
                title: l10n.studentMarket,
                subtitle: l10n.isArabic ? 'بيع واشتري مع الطلاب' : 'Buy & sell with students',
                color: const Color(0xFF10B981),
                route: '/market',
              ),
            _ServiceItem(
              icon: Icons.local_laundry_service_outlined,
              title: l10n.laundryCleaning,
              subtitle: l10n.isArabic ? 'غسيل وتنظيف بأسعار طلابية' : 'Laundry & cleaning services',
              color: const Color(0xFFF59E0B),
              route: '/services',
            ),
            _ServiceItem(
              icon: Icons.receipt_long_outlined,
              title: l10n.orders,
              subtitle: l10n.isArabic ? 'تتبع طلباتك' : 'Track your orders',
              color: const Color(0xFFEC4899),
              route: '/orders',
            ),
            _ServiceItem(
              icon: Icons.chat_bubble_outline_rounded,
              title: l10n.inbox,
              subtitle: l10n.isArabic ? 'رسائلك ومحادثاتك' : 'Messages & conversations',
              color: const Color(0xFF06B6D4),
              route: '/chat/inbox',
            ),
            _ServiceItem(
              icon: Icons.settings_outlined,
              title: l10n.settings,
              subtitle: l10n.isArabic ? 'اللغة، المظهر، الحساب' : 'Language, theme, account',
              color: const Color(0xFF64748B),
              route: '/settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, AppLocalizations l10n) {
    final orders = context.watch<OrdersProvider>().orders;
    final chats = context.watch<ChatProvider>().inbox;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : ThemeProvider.border,
        ),
      ),
      child: Row(
        children: [
          _StatItem(
            value: '${orders.where((o) => o.status == 'Pending').length}',
            label: l10n.isArabic ? 'معلقة' : 'Pending',
            color: const Color(0xFFF59E0B),
          ),
          _statDivider(isDark),
          _StatItem(
            value: '${chats.length}',
            label: l10n.isArabic ? 'محادثات' : 'Chats',
            color: const Color(0xFF06B6D4),
          ),
          _statDivider(isDark),
          _StatItem(
            value: '${orders.where((o) => o.status == 'Completed').length}',
            label: l10n.isArabic ? 'مكتملة' : 'Done',
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _statDivider(bool isDark) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isDark ? const Color(0xFF2A2A2A) : ThemeProvider.border,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : ThemeProvider.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;

  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pushNamed(context, route),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF2A2A2A) : ThemeProvider.border,
              ),
            ),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : ThemeProvider.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeProvider.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFD1D5DB),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
