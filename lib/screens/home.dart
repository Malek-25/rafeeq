import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/orders_provider.dart';
import '../core/providers/chat_provider.dart';
import '../core/utils/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    // Check authentication - redirect to sign-in if not authenticated
    if (!app.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/auth/sign-in');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userName = app.userName ?? app.userEmail?.split('@')[0] ?? 'User';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Beautiful App Bar with gradient
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.7),
                      colorScheme.tertiary.withOpacity(0.6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l10n.welcome}, $userName',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      app.role == UserRole.provider ? l10n.provider : l10n.student,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Notifications icon
                            IconButton(
                              onPressed: () => Navigator.pushNamed(context, '/chat/inbox'),
                              icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          l10n.whatWouldYouLikeToDo,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Quick stats row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: _QuickStatsRow(),
            ),
          ),

          // Section title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Text(
                l10n.services,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
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
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _ServiceCard(
                  title: l10n.housing,
                  icon: Icons.home_rounded,
                  route: '/housing',
                  gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                  subtitle: l10n.isArabic ? 'ابحث عن سكن' : 'Find a place',
                ),
                if (app.role == UserRole.student)
                  _ServiceCard(
                    title: l10n.studentMarket,
                    icon: Icons.storefront_rounded,
                    route: '/market',
                    gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                    subtitle: l10n.isArabic ? 'بيع واشتري' : 'Buy & sell',
                  ),
                _ServiceCard(
                  title: l10n.laundryCleaning,
                  icon: Icons.local_laundry_service_rounded,
                  route: '/services',
                  gradient: const [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
                  subtitle: l10n.isArabic ? 'غسيل وتنظيف' : 'Fresh & clean',
                ),
                _ServiceCard(
                  title: l10n.orders,
                  icon: Icons.receipt_long_rounded,
                  route: '/orders',
                  gradient: const [Color(0xFFF093FB), Color(0xFFF5576C)],
                  subtitle: l10n.isArabic ? 'تتبع طلباتك' : 'Track orders',
                ),
                _ServiceCard(
                  title: l10n.inbox,
                  icon: Icons.forum_rounded,
                  route: '/chat/inbox',
                  gradient: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  subtitle: l10n.isArabic ? 'رسائلك' : 'Your messages',
                ),
                _ServiceCard(
                  title: l10n.settings,
                  icon: Icons.settings_rounded,
                  route: '/settings',
                  gradient: const [Color(0xFF43E97B), Color(0xFF38F9D7)],
                  subtitle: l10n.isArabic ? 'تخصيص' : 'Customize',
                ),
                _ServiceCard(
                  title: l10n.profile,
                  icon: Icons.person_rounded,
                  route: '/profile',
                  gradient: const [Color(0xFFFa709A), Color(0xFFFEE140)],
                  subtitle: l10n.isArabic ? 'ملفك الشخصي' : 'Your profile',
                ),
              ]),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    final pendingOrders = orders.where((o) => o.status == 'Pending').length;
    final unreadChats = chatThreads.length;

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.pending_actions_rounded,
            label: l10n.isArabic ? 'طلبات معلقة' : 'Pending',
            value: '$pendingOrders',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            icon: Icons.chat_bubble_outline_rounded,
            label: l10n.isArabic ? 'محادثات' : 'Chats',
            value: '$unreadChats',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            icon: Icons.check_circle_outline_rounded,
            label: l10n.isArabic ? 'مكتملة' : 'Completed',
            value: '${orders.where((o) => o.status == 'Completed').length}',
            color: Colors.green,
          ),
        ),
      ],
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(theme.brightness == Brightness.dark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Service Card with gradient
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
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? widget.gradient.map((c) => c.withOpacity(0.7)).toList()
                      : widget.gradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.first.withOpacity(isDark ? 0.2 : 0.3),
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
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
