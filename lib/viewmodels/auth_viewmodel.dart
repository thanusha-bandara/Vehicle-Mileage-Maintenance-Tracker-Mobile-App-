import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AppUser? _user;
  AppUser? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    // Listen to authentication state changes when the app starts
    _authService.authStateChanges.listen((AppUser? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);
    
    AppUser? result = await _authService.signInWithEmailAndPassword(email, password);
    
    _setLoading(false);
    if (result == null) {
      _setErrorMessage("Login Failed. Please check your email and password.");
      return false;
    }
    return true;
  }

  Future<bool> register(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);
    
    AppUser? result = await _authService.registerWithEmailAndPassword(email, password);
    
    _setLoading(false);
    if (result == null) {
      _setErrorMessage("Registration Failed. Please try again.");
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
