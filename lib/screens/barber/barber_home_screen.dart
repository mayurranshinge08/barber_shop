import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/queue_service.dart';
import '../../widgets/add_customer_dialog.dart';
import '../../widgets/current_customer_card.dart';
import '../../widgets/queue_list.dart';
import '../../widgets/stats_card.dart';
import '../auth/login_screen.dart';

class BarberHomeScreen extends StatelessWidget {
  const BarberHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Barber Dashboard',
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
                  actions: [
                    Consumer<AuthService>(
                      builder: (context, authService, child) {
                        return PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  child: const Row(
                                    children: [
                                      Icon(Icons.logout),
                                      SizedBox(width: 8),
                                      Text('Logout'),
                                    ],
                                  ),
                                  onTap: () async {
                                    await authService.logout();
                                    if (context.mounted) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const LoginScreen(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                        );
                      },
                    ),
                  ],
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
    );
  }
}
