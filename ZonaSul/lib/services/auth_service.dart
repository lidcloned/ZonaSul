import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream de alterações de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registrar com email e senha
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String gameName,
    required String whatsapp,
  }) async {
    try {
      // Criar usuário no Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Criar perfil do usuário no Firestore
      await _createUserProfile(
        uid: result.user!.uid,
        username: username,
        email: email,
        gameName: gameName,
        whatsapp: whatsapp,
      );
      
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Criar perfil do usuário no Firestore
  Future<void> _createUserProfile({
    required String uid,
    required String username,
    required String email,
    required String gameName,
    required String whatsapp,
  }) async {
    // Verificar se é o primeiro usuário (será o dono)
    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
    String role = usersSnapshot.docs.isEmpty ? 'owner' : 'member';
    
    // Data de ingresso
    String joinDate = DateTime.now().toIso8601String();
    
    // Criar modelo de usuário
    UserModel user = UserModel(
      uid: uid,
      username: username,
      email: email,
      gameName: gameName,
      whatsapp: whatsapp,
      role: role,
      joinDate: joinDate,
    );
    
    // Salvar no Firestore
    await _firestore.collection('users').doc(uid).set(user.toMap());
  }

  // Login com email e senha
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Obter dados do usuário atual
  Future<UserModel?> getCurrentUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar perfil do usuário
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Verificar se o usuário é administrador ou dono
  Future<bool> isAdminOrOwner() async {
    try {
      UserModel? user = await getCurrentUserData();
      return user != null && (user.role == 'admin' || user.role == 'owner');
    } catch (e) {
      return false;
    }
  }

  // Verificar se o usuário é dono
  Future<bool> isOwner() async {
    try {
      UserModel? user = await getCurrentUserData();
      return user != null && user.role == 'owner';
    } catch (e) {
      return false;
    }
  }
}
