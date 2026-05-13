import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/orders_provider.dart';
import '../core/utils/app_localizations.dart';
import '../core/widgets/shimmer_loading.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orders),
        actions: [
          if (orders.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text(
                  '${orders.length}',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
      body: orders.isEmpty
          ? EmptyStateWidget(
              icon: Icons.receipt_long_rounded,
              title: l10n.noOrdersYet,
              subtitle: l10n.isArabic
                  ? 'طلباتك ستظهر هنا بعد الطلب'
                  : 'Your orders will appear here after you place one',
              gradientColors: const [Color(0xFFF093FB), Color(0xFFF5576C)],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final order = orders[i];
                return _OrderCard(order: order, l10n: l10n);
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderItem order;
  final AppLocalizations l10n;

  const _OrderCard({required this.order, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Status config
    Color statusColor;
    IconData statusIcon;
    String statusText;
    switch (order.status) {
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule_rounded;
        statusText = l10n.pending;
        break;
      case 'Accepted':
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle_outline_rounded;
        statusText = l10n.accepted;
        break;
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.task_alt_rounded;
        statusText = l10n.completed;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusText = order.status;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? colorScheme.surfaceContainerHighest
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Status indicator dot
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.type == 'service' ? (l10n.isArabic ? 'خدمة' : 'Service') : (l10n.isArabic ? 'منتج' : 'Product')} • #${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${order.amount.toStringAsFixed(2)} ${l10n.jod}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
                // Status chip
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: colorScheme.onSurface.withOpacity(0.5),
                        size: 20,
                      ),
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'Pending', child: Text(l10n.pending)),
                        PopupMenuItem(value: 'Accepted', child: Text(l10n.accepted)),
                        PopupMenuItem(value: 'Completed', child: Text(l10n.completed)),
                      ],
                      onSelected: (v) => context.read<OrdersProvider>().setStatus(order.id, v),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
