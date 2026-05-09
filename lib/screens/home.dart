import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/orders_provider.dart';
import '../core/providers/chat_provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/utils/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isDark = theme.brightness == Brightness.dark;

    if (!app.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/auth/sign-in');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userName = app.userName ?? app.userEmail?.split('@')[0] ?? 'User';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1565C0),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF1565C0),
                      Color(0xFF1976D2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Avatar with white border
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                                color: const Color(0xFFFFAB00),
                              ),
                              child: Center(
                                child: Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l10n.welcome}, $userName',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFAB00),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      app.role == UserRole.provider ? l10n.provider : l10n.student,
                                      style: const TextStyle(
                                        color: Color(0xFF1A1A2E),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Notification bell
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => Navigator.pushNamed(context, '/chat/inbox'),
                                icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          l10n.whatWouldYouLikeToDo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: _QuickStatsRow(),
            ),
          ),

          // Section title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
              child: Text(
                l10n.services,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),

          // Service Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
              ),
              delegate: SliverChildListDelegate([
                _ServiceCard(
                  title: l10n.housing,
                  icon: Icons.home_rounded,
                  route: '/housing',
                  gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  subtitle: l10n.isArabic ? 'ابحث عن سكن' : 'Find a place',
                ),
                if (app.role == UserRole.student)
                  _ServiceCard(
                    title: l10n.studentMarket,
                    icon: Icons.storefront_rounded,
                    route: '/market',
                    gradient: const [Color(0xFF00897B), Color(0xFF26A69A)],
                    subtitle: l10n.isArabic ? 'بيع واشتري' : 'Buy & sell',
                  ),
                _ServiceCard(
                  title: l10n.laundryCleaning,
                  icon: Icons.local_laundry_service_rounded,
                  route: '/services',
                  gradient: const [Color(0xFFE65100), Color(0xFFFF6D00)],
                  subtitle: l10n.isArabic ? 'غسيل وتنظيف' : 'Fresh & clean',
                ),
                _ServiceCard(
                  title: l10n.orders,
                  icon: Icons.receipt_long_rounded,
                  route: '/orders',
                  gradient: const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                  subtitle: l10n.isArabic ? 'تتبع طلباتك' : 'Track orders',
                ),
                _ServiceCard(
                  title: l10n.inbox,
                  icon: Icons.forum_rounded,
                  route: '/chat/inbox',
                  gradient: const [Color(0xFF00838F), Color(0xFF00BCD4)],
                  subtitle: l10n.isArabic ? 'رسائلك' : 'Your messages',
                ),
                _ServiceCard(
                  title: l10n.settings,
                  icon: Icons.settings_rounded,
                  route: '/settings',
                  gradient: const [Color(0xFF37474F), Color(0xFF607D8B)],
                  subtitle: l10n.isArabic ? 'تخصيص' : 'Customize',
                ),
                _ServiceCard(
                  title: l10n.profile,
                  icon: Icons.person_rounded,
                  route: '/profile',
                  gradient: const [Color(0xFFC62828), Color(0xFFEF5350)],
                  subtitle: l10n.isArabic ? 'ملفك الشخصي' : 'Your profile',
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

// Quick Stats Row
class _QuickStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final chatThreads = context.watch<ChatProvider>().inbox;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pendingOrders = orders.where((o) => o.status == 'Pending').length;
    final unreadChats = chatThreads.length;
    final completedOrders = orders.where((o) => o.status == 'Completed').length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              icon: Icons.pending_actions_rounded,
              label: l10n.isArabic ? 'معلقة' : 'Pending',
              value: '$pendingOrders',
              color: const Color(0xFFFF6D00),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
          Expanded(
            child: _StatChip(
              icon: Icons.chat_bubble_rounded,
              label: l10n.isArabic ? 'محادثات' : 'Chats',
              value: '$unreadChats',
              color: const Color(0xFF1565C0),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
          Expanded(
            child: _StatChip(
              icon: Icons.check_circle_rounded,
              label: l10n.isArabic ? 'مكتملة' : 'Done',
              value: '$completedOrders',
              color: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[400] : const Color(0xFF546E7A),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// Service Card
class _ServiceCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final List<Color> gradient;

  const _ServiceCard({
    required this.title,
    required this.icon,
    required this.route,
    required this.gradient,
    required this.subtitle,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, widget.route);
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.gradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.first.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon in white circle-ish background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    // Text at bottom
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
