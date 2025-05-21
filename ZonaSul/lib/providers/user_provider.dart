import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  // Inicializar o provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUserData();
    } catch (e) {
      debugPrint('Erro ao inicializar UserProvider: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Registrar usuário
  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String gameName,
    required String whatsapp,
  }) async {
    _setLoading(true);
    try {
      await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
        gameName: gameName,
        whatsapp: whatsapp,
      );
      _user = await _authService.getCurrentUserData();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = await _authService.getCurrentUserData();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Atualizar perfil
  Future<void> updateProfile({
    String? username,
    String? gameName,
    String? whatsapp,
    String? profileImageUrl,
  }) async {
    if (_user == null) return;

    _setLoading(true);
    try {
      UserModel updatedUser = _user!.copyWith(
        username: username,
        gameName: gameName,
        whatsapp: whatsapp,
        profileImageUrl: profileImageUrl,
      );
      
      await _authService.updateUserProfile(updatedUser);
      _user = updatedUser;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Verificar se é admin ou dono
  Future<bool> isAdminOrOwner() async {
    return await _authService.isAdminOrOwner();
  }

  // Verificar se é dono
  Future<bool> isOwner() async {
    return await _authService.isOwner();
  }

  // Atualizar estado de carregamento
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
