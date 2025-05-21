import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _gameNameController = TextEditingController();
  final _whatsappController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _gameNameController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Junte-se ao Clã',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            // Mensagem de erro
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            
            // Campos de registro
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nome de Usuário',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Senha',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _gameNameController,
              decoration: const InputDecoration(
                labelText: 'Nome no Jogo',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Número do WhatsApp',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 24),
            
            // Botão de registro
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7289DA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('REGISTRAR'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    // Validar campos
    if (!_validateFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Tentar registro
      await Provider.of<UserProvider>(context, listen: false).register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        gameName: _gameNameController.text.trim(),
        whatsapp: _whatsappController.text.trim(),
      );
      
      // Registro bem-sucedido, mostrar diálogo e voltar para login
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registro Concluído'),
            content: const Text('Sua conta foi criada com sucesso! Você pode fazer login agora.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar diálogo
                  Navigator.of(context).pop(); // Voltar para tela de login
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Tratar erro de registro
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateFields() {
    // Verificar campos vazios
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _gameNameController.text.isEmpty ||
        _whatsappController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return false;
    }
    
    // Verificar formato de email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Por favor, insira um email válido.';
      });
      return false;
    }
    
    // Verificar se as senhas coincidem
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'As senhas não coincidem.';
      });
      return false;
    }
    
    // Verificar comprimento da senha
    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
      });
      return false;
    }
    
    return true;
  }

  String _getErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Este email já está em uso. Tente outro email.';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido. Verifique o formato.';
    } else if (error.contains('weak-password')) {
      return 'Senha muito fraca. Use uma senha mais forte.';
    } else if (error.contains('operation-not-allowed')) {
      return 'Operação não permitida. Contate o administrador.';
    } else {
      return 'Erro ao criar conta. Tente novamente.';
    }
  }
}
