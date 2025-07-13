import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final int position;
  final VoidCallback onComplete;
  final VoidCallback onRemove;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.position,
    required this.onComplete,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient:
              customer.isCompleted
                  ? const LinearGradient(
                    colors: [Color(0xFFE8F5E8), Color(0xFFD4EDDA)],
                  )
                  : position == 1
                  ? const LinearGradient(
                    colors: [Color(0xFFFFF3CD), Color(0xFFFFE69C)],
                  )
                  : const LinearGradient(
                    colors: [Colors.white, Color(0xFFF8F9FA)],
                  ),
          border: Border.all(
            color:
                customer.isCompleted
                    ? const Color(0xFF4CAF50)
                    : position == 1
                    ? const Color(0xFFFFC107)
                    : Colors.grey.shade200,
            width: customer.isCompleted || position == 1 ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Position Badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient:
                      customer.isCompleted
                          ? const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                          )
                          : position == 1
                          ? const LinearGradient(
                            colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
                          )
                          : const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child:
                      customer.isCompleted
                          ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                          : Text(
                            position.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),

              const SizedBox(width: 16),

              // Customer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customer.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  customer.isCompleted
                                      ? Colors.grey.shade600
                                      : const Color(0xFF2C3E50),
                              decoration:
                                  customer.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),
                        ),
                        if (position == 1 && !customer.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC107),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'NEXT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.contactNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeFormat.format(customer.addedTime),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              if (!customer.isCompleted) ...[
                const SizedBox(width: 8),
                Column(
                  children: [
                    IconButton(
                      onPressed: onComplete,
                      icon: const Icon(Icons.check_circle),
                      color: const Color(0xFF4CAF50),
                      tooltip: 'Complete Service',
                    ),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                      tooltip: 'Remove from Queue',
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
