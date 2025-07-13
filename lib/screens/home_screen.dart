import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/queue_service.dart';
import '../widgets/add_customer_dialog.dart';
import '../widgets/current_customer_card.dart';
import '../widgets/queue_list.dart';
import '../widgets/stats_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QueueService(),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<QueueService>(
            builder: (context, queueService, child) {
              return CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        'Barber Queue',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                title: 'In Queue',
                                value: queueService.queueLength.toString(),
                                icon: Icons.people,
                                color: const Color(0xFF667eea),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatsCard(
                                title: 'Completed',
                                value:
                                    queueService.customers
                                        .where((c) => c.isCompleted)
                                        .length
                                        .toString(),
                                icon: Icons.check_circle,
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Current Customer
                        if (queueService.currentCustomer != null)
                          CurrentCustomerCard(
                            customer: queueService.currentCustomer!,
                            onComplete: () {
                              queueService.completeService(
                                queueService.currentCustomer!.id,
                              );
                            },
                          ),

                        const SizedBox(height: 24),

                        // Queue Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Queue',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            if (queueService.customers
                                .where((c) => c.isCompleted)
                                .isNotEmpty)
                              TextButton.icon(
                                onPressed: () {
                                  queueService.clearCompletedCustomers();
                                },
                                icon: const Icon(Icons.clear_all),
                                label: const Text('Clear Completed'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Queue List
                        QueueList(customers: queueService.customers),

                        const SizedBox(height: 100), // Space for FAB
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Consumer<QueueService>(
          builder: (context, queueService, child) {
            return FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AddCustomerDialog(
                        onAdd: (name, contact) {
                          queueService.addCustomer(name, contact);
                        },
                      ),
                );
              },
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add),
              label: const Text(
                'Add Customer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}
