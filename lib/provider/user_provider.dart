import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  // Constructor initializes with default User object
  // Purpose: Manage the state of the user object allowing updates
  UserNotifier()
    : super(
        User(
          id: '',
          fullName: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          gender: '',
          password: '',
          token: '',
        ),
      );

  // Get the current user
  User? get user => state;

  // Set the current user
  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  // Method to clear the user data
  void signOut() {
    state = null;
  }

  // Method to refresh the user data
  void refreshUser({required String userJson}) {
    state = User.fromJson(userJson);
  }
}

// Make the data accessible within the application
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
