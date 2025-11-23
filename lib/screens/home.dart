import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/locale_provider.dart';
import '../core/services/biometric_service.dart';
import '../core/utils/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Helper method to get adaptive colors that work well in both light and dark mode
  static Color _getAdaptiveColor(BuildContext context, Color lightColor) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      // In dark mode, use brighter, more saturated colors for better visibility
      return lightColor.withOpacity(0.9);
    }
    return lightColor;
  }

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
      // Return a loading screen while redirecting
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button on home screen
        title: Text(
          l10n.appName, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.4),
              colorScheme.surfaceContainerHighest.withOpacity(0.2),
              colorScheme.surface,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withOpacity(0.1),
                    colorScheme.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.waving_hand_rounded,
                      color: colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.welcome,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.whatWouldYouLikeToDo,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Show user role
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: app.role == UserRole.provider 
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            app.role == UserRole.provider ? l10n.provider : l10n.student,
                            style: TextStyle(
                              color: app.role == UserRole.provider 
                                ? Colors.orange.shade700
                                : Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Services Grid
            Text(
              l10n.services,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _HomeTile(title: l10n.housing, icon: Icons.home_rounded, route: '/housing', color: _getAdaptiveColor(context, const Color(0xFF2196F3))),
                if(app.role == UserRole.student) 
                  _HomeTile(title: l10n.studentMarket, icon: Icons.storefront_rounded, route: '/market', color: _getAdaptiveColor(context, const Color(0xFF4CAF50))),
                _HomeTile(title: l10n.laundryCleaning, icon: Icons.local_laundry_service_rounded, route: '/services', color: _getAdaptiveColor(context, const Color(0xFFFF9800))),
                _HomeTile(title: l10n.orders, icon: Icons.receipt_long_rounded, route: '/orders', color: _getAdaptiveColor(context, const Color(0xFF3F51B5))),
                _HomeTile(title: l10n.inbox, icon: Icons.forum_rounded, route: '/chat/inbox', color: _getAdaptiveColor(context, const Color(0xFF009688))),
                _HomeTile(title: l10n.settings, icon: Icons.settings_rounded, route: '/settings', color: _getAdaptiveColor(context, const Color(0xFF607D8B))),
                _HomeTile(title: l10n.profile, icon: Icons.person_rounded, route: '/profile', color: _getAdaptiveColor(context, const Color(0xFFE91E63))),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HomeTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final String route;
  final Color color;
  
  const _HomeTile({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });

  @override
  State<_HomeTile> createState() => _HomeTileState();
}

class _HomeTileState extends State<_HomeTile> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
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
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        Navigator.pushNamed(context, widget.route);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 170,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surfaceContainerHighest,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.15),
                    blurRadius: 16 + _elevationAnimation.value,
                    offset: Offset(0, 4 + _elevationAnimation.value / 2),
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: _isPressed 
                    ? widget.color.withOpacity(theme.brightness == Brightness.dark ? 0.6 : 0.4)
                    : widget.color.withOpacity(theme.brightness == Brightness.dark ? 0.25 : 0.15),
                  width: _isPressed ? 2 : 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.2),
                          widget.color.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(theme.brightness == Brightness.dark ? 0.5 : 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      size: 40, // Slightly larger icon for better visibility
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
