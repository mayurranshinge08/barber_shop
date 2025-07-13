import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';

class QueueService extends ChangeNotifier {
  List<Customer> _customers = [];
  static const String _storageKey = 'barber_queue';

  List<Customer> get customers => _customers;

  List<Customer> get activeCustomers =>
      _customers.where((customer) => !customer.isCompleted).toList();

  int get queueLength => activeCustomers.length;

  Customer? get currentCustomer =>
      activeCustomers.isNotEmpty ? activeCustomers.first : null;

  QueueService() {
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? queueData = prefs.getString(_storageKey);

      if (queueData != null) {
        final List<dynamic> jsonList = json.decode(queueData);
        _customers = jsonList.map((json) => Customer.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading queue: $e');
    }
  }

  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String queueData = json.encode(
        _customers.map((customer) => customer.toJson()).toList(),
      );
      await prefs.setString(_storageKey, queueData);
    } catch (e) {
      debugPrint('Error saving queue: $e');
    }
  }

  Future<void> addCustomer(String name, String contactNumber) async {
    final customer = Customer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      contactNumber: contactNumber,
      addedTime: DateTime.now(),
    );

    _customers.add(customer);
    await _saveQueue();
    notifyListeners();
  }

  Future<void> completeService(String customerId) async {
    final customerIndex = _customers.indexWhere((c) => c.id == customerId);
    if (customerIndex != -1) {
      _customers[customerIndex].isCompleted = true;
      await _saveQueue();
      notifyListeners();
    }
  }

  Future<void> removeCustomer(String customerId) async {
    _customers.removeWhere((customer) => customer.id == customerId);
    await _saveQueue();
    notifyListeners();
  }

  int getPositionInQueue(String customerId) {
    final activeList = activeCustomers;
    final index = activeList.indexWhere(
      (customer) => customer.id == customerId,
    );
    return index + 1;
  }

  Future<void> clearCompletedCustomers() async {
    _customers.removeWhere((customer) => customer.isCompleted);
    await _saveQueue();
    notifyListeners();
  }
}
