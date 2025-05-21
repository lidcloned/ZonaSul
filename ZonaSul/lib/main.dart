import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LAMAFIAApp());
}

class LAMAFIAApp extends StatelessWidget {
  const LAMAFIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'LAMAFIA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7289DA), // Cor inspirada no Discord
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF36393F), // Fundo escuro estilo Discord
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF202225), // Barra superior escura
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Inicializar o provider quando o estado de autenticação mudar
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          
          if (user != null) {
            // Usuário autenticado, inicializar provider e ir para dashboard
            Provider.of<UserProvider>(context, listen: false).initialize();
            return const DashboardScreen();
          }
          
          // Usuário não autenticado, ir para tela de login
          return const LoginScreen();
        }
        
        // Conexão em andamento, mostrar indicador de carregamento
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
