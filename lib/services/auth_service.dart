import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';
  static const String _barbersKey = 'registered_barbers';

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isBarber => _currentUser?.role == UserRole.barber;
  bool get isCustomer => _currentUser?.role == UserRole.customer;

  AuthService() {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userData = prefs.getString(_userKey);

      if (userData != null) {
        _currentUser = User.fromJson(json.decode(userData));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  Future<void> _saveCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser != null) {
        await prefs.setString(_userKey, json.encode(_currentUser!.toJson()));
      } else {
        await prefs.remove(_userKey);
      }
    } catch (e) {
      debugPrint('Error saving current user: $e');
    }
  }

  Future<List<User>> _getRegisteredUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? usersData = prefs.getString(_usersKey);

      if (usersData != null) {
        final List<dynamic> jsonList = json.decode(usersData);
        return jsonList.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error loading registered users: $e');
      return [];
    }
  }

  Future<void> _saveRegisteredUsers(List<User> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String usersData = json.encode(
        users.map((user) => user.toJson()).toList(),
      );
      await prefs.setString(_usersKey, usersData);
    } catch (e) {
      debugPrint('Error saving registered users: $e');
    }
  }

  Future<Map<String, String>> _getRegisteredBarbers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? barbersData = prefs.getString(_barbersKey);

      if (barbersData != null) {
        final Map<String, dynamic> jsonMap = json.decode(barbersData);
        return jsonMap.cast<String, String>();
      }

      // Default barber account
      return {'admin': 'barber123'};
    } catch (e) {
      debugPrint('Error loading registered barbers: $e');
      return {'admin': 'barber123'};
    }
  }

  Future<void> _saveRegisteredBarbers(Map<String, String> barbers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_barbersKey, json.encode(barbers));
    } catch (e) {
      debugPrint('Error saving registered barbers: $e');
    }
  }

  // Customer Registration
  Future<String?> registerCustomer(
    String name,
    String contactNumber,
    String password,
  ) async {
    try {
      final users = await _getRegisteredUsers();

      // Check if user already exists
      final existingUser =
          users
              .where((user) => user.contactNumber == contactNumber)
              .firstOrNull;

      if (existingUser != null) {
        return 'User with this contact number already exists';
      }

      // Create new customer
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        contactNumber: contactNumber,
        password: password,
        role: UserRole.customer,
        createdAt: DateTime.now(),
      );

      users.add(newUser);
      await _saveRegisteredUsers(users);
      return null; // Success
    } catch (e) {
      debugPrint('Error during customer registration: $e');
      return 'Registration failed. Please try again.';
    }
  }

  // Customer Login
  Future<String?> loginCustomer(String contactNumber, String password) async {
    try {
      final users = await _getRegisteredUsers();

      final user =
          users
              .where(
                (user) =>
                    user.contactNumber == contactNumber &&
                    user.password == password,
              )
              .firstOrNull;

      if (user != null) {
        _currentUser = user;
        await _saveCurrentUser();
        notifyListeners();
        return null; // Success
      } else {
        return 'Invalid contact number or password';
      }
    } catch (e) {
      debugPrint('Error during customer login: $e');
      return 'Login failed. Please try again.';
    }
  }

  // Barber Registration
  Future<String?> registerBarber(
    String username,
    String password,
    String name,
  ) async {
    try {
      final barbers = await _getRegisteredBarbers();

      if (barbers.containsKey(username)) {
        return 'Username already exists';
      }

      barbers[username] = password;
      await _saveRegisteredBarbers(barbers);
      return null; // Success
    } catch (e) {
      debugPrint('Error during barber registration: $e');
      return 'Registration failed. Please try again.';
    }
  }

  // Barber Login
  Future<String?> loginBarber(String username, String password) async {
    try {
      final barbers = await _getRegisteredBarbers();

      if (barbers[username] == password) {
        _currentUser = User(
          id: 'barber_$username',
          name: username,
          contactNumber: '0000000000',
          password: password,
          role: UserRole.barber,
          createdAt: DateTime.now(),
        );

        await _saveCurrentUser();
        notifyListeners();
        return null; // Success
      } else {
        return 'Invalid username or password';
      }
    } catch (e) {
      debugPrint('Error during barber login: $e');
      return 'Login failed. Please try again.';
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _saveCurrentUser();
    notifyListeners();
  }
}
