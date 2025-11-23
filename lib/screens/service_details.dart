import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/orders_provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  double qty = 1.0; // Changed to double to support half hours
  
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> s = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final title = s['title'] as String;
    final price = (s['price'] as num).toDouble();
    final desc = s['desc'] as String;
    final unit = s['unit'] as String? ?? 'item';
    final total = (qty * price);
    
    // Determine if this is a cleaning service (time-based)
    final isTimeBasedService = unit == 'hour';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                ),
              ),
              child: Icon(
                Icons.local_laundry_service_rounded,
                size: 80,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الوصف',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            desc,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Price Card
                  Card(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'سعر الوحدة',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${price.toStringAsFixed(2)} د.أ',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getUnitDisplayName(s['unit'] as String? ?? 'item'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Quantity Selector
                  Text(
                    'الكمية',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (isTimeBasedService) {
                                  if (qty > 1.0) qty -= 0.5; // Decrease by half hour
                                } else {
                                  if (qty > 1) qty -= 1; // Decrease by 1 item
                                }
                              });
                            },
                            icon: Icon(
                              Icons.remove_circle_outline_rounded,
                              color: qty > (isTimeBasedService ? 1.0 : 1) ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.3),
                            ),
                            iconSize: 32,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isTimeBasedService 
                                  ? '${qty == qty.toInt() ? qty.toInt() : qty} ${qty == 1 ? 'ساعة' : qty == 0.5 ? 'نصف ساعة' : 'ساعات'}'
                                  : '${qty.toInt()} ${_getUnitDisplayName(unit)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (isTimeBasedService) {
                                  qty += 0.5; // Increase by half hour
                                } else {
                                  qty += 1; // Increase by 1 item
                                }
                              });
                            },
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              color: colorScheme.primary,
                            ),
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Total Price Card
                  Card(
                    elevation: 4,
                    color: colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المبلغ الإجمالي',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimary.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${total.toStringAsFixed(2)} د.أ',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            color: colorScheme.onPrimary,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Order Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () {
                        final qtyText = isTimeBasedService 
                            ? '${qty == qty.toInt() ? qty.toInt() : qty} ${qty == 1 ? 'ساعة' : qty == 0.5 ? 'نصف ساعة' : 'ساعات'}'
                            : '${qty.toInt()} ${_getUnitDisplayName(unit)}';
                            
                        final order = OrderItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: 'service',
                          title: '$title x$qtyText',
                          amount: total,
                        );
                        context.read<OrdersProvider>().addOrder(order);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('تم إرسال الطلب بنجاح'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        Navigator.popUntil(context, ModalRoute.withName('/orders'));
                      },
                      icon: const Icon(Icons.shopping_cart_rounded),
                      label: const Text(
                        'اطلب الآن',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUnitDisplayName(String unit) {
    switch(unit) {
      case 'item': return 'قطعة';
      case 'basket': return 'سلة';
      case 'hour': return 'ساعة';
      default: return 'قطعة';
    }
  }
}
