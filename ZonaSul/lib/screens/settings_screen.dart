import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/test_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Seção de Perfil
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Editar Perfil'),
                    subtitle: const Text('Alterar informações pessoais'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navegar para tela de edição de perfil
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Alterar Foto'),
                    subtitle: const Text('Atualizar imagem de perfil'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navegar para tela de alteração de foto
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Alterar Senha'),
                    subtitle: const Text('Atualizar senha de acesso'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navegar para tela de alteração de senha
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Seção de Notificações
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notificações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Notificações de Missões'),
                    subtitle: const Text('Receber alertas sobre novas missões'),
                    value: true,
                    onChanged: (value) {
                      // Atualizar configuração
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Notificações de Chat'),
                    subtitle: const Text('Receber alertas de novas mensagens'),
                    value: true,
                    onChanged: (value) {
                      // Atualizar configuração
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Notificações de Eventos'),
                    subtitle: const Text('Receber alertas sobre eventos do clã'),
                    value: true,
                    onChanged: (value) {
                      // Atualizar configuração
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Seção de Aparência
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aparência',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: const Text('Tema'),
                    subtitle: const Text('Escuro (padrão)'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Abrir seletor de tema
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.font_download),
                    title: const Text('Tamanho da Fonte'),
                    subtitle: const Text('Médio (padrão)'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Abrir seletor de tamanho de fonte
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Seção de Suporte e Informações
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Suporte e Informações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Ajuda'),
                    subtitle: const Text('Perguntas frequentes e suporte'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navegar para tela de ajuda
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Sobre'),
                    subtitle: const Text('Informações sobre o aplicativo'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Mostrar diálogo com informações
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF36393F),
                          title: const Text('Sobre LAMAFIA'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Versão: 1.0.0'),
                              SizedBox(height: 8),
                              Text('Aplicativo de gerenciamento de clã com interface inspirada no Discord.'),
                              SizedBox(height: 16),
                              Text('© 2025 LAMAFIA. Todos os direitos reservados.'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('Testes e Diagnóstico'),
                    subtitle: const Text('Verificar funcionamento do aplicativo'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navegar para tela de testes
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TestScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Botão de Logout
          ElevatedButton.icon(
            onPressed: () async {
              // Confirmar logout
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF36393F),
                  title: const Text('Sair'),
                  content: const Text('Tem certeza que deseja sair da sua conta?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                // Fazer logout
                await userProvider.logout();
              }
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text('SAIR DA CONTA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 32),
          
          // Versão do aplicativo
          Center(
            child: Text(
              'LAMAFIA v1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
